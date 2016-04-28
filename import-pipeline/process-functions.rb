require 'date'
require 'json'
require 'pg'
require 'RMagick'
require 'thread'
require 'yaml'
require_relative 'geotiff.rb'

@debug = ARGV[0] == '--debug'

def scene_is_landsat8(filename)
  return filename[0..2] == "LC8"
end

def process_data(sub, s3_subfolder, process_q)
  group_name = s3_subfolder

  db_config_file = File.join(SRC_DIRECTORY, 'db.yml')

  if File.exist?(db_config_file)
    db_config = YAML.load(File.read(db_config_file))
  else
    db_config = { dbname: "kelp_world" }
  end

  client = PG.connect(db_config)

  no_rows  = 20
  no_colls = 20

  image_width  = 7981
  image_height = 7271

  scale = 1.0

  image_chunk_width = image_width / no_rows
  image_chunk_height = image_height / no_colls

  manifest = []
  rejected_manifest = []

  lc8_channels = {r:6 , g:5 , b:4}
  other_channels = {r:5 , g:4 , b:3}

  while raw_scene = process_q.pop
    begin

      target_squares = []

      file_name = File.basename(raw_scene)
      base_name = File.basename(raw_scene, ".tar.gz")

      `mkdir -p temp/#{base_name}`
      puts "Extracting data from #{file_name}"
      `tar -xzvf #{raw_scene} -C temp/#{base_name}`

      if scene_is_landsat8(base_name)
        channels = lc8_channels
      else
        channels = other_channels
      end

      # Exract UTM data from source files
      src_files = {}
      channels.each_value do |v|
        src_files[v] = "./temp/#{base_name}/#{base_name}_B#{v}.TIF"
      end

      # Extract meta data
      meta_data = IO.read("temp/#{base_name}/#{base_name}_MTL.txt").split("\n")

      lat_long = meta_data.select{|a| a.include?("CORNER_UR_L") || a.include?("CORNER_LL_L")}.inject({}){|r,l| kv = l.split("=").collect{|l| l.strip}; r[kv[0]] = kv[1].to_f; r}
      date = meta_data.select{|a| a.include?("DATE_ACQUIRED")}.first.split("=").last.strip
      time = meta_data.select{|a| a.include?("SCENE_CENTER_TIME")}.first.split("=").last.strip

      image_time = DateTime.parse(date + " " + time)

      full_ll = [lat_long["CORNER_LL_LON_PRODUCT"], lat_long["CORNER_LL_LAT_PRODUCT"]]
      full_ur = [lat_long["CORNER_UR_LON_PRODUCT"], lat_long["CORNER_UR_LAT_PRODUCT"]]

      # Check that Landsat scene contains any coastline before processing further
      if client.exec("select count(*) as ls from coast where ST_Intersects(ST_SetSRID(ST_MakeBox2D(ST_Point(#{full_ll.join(", ")}), ST_Point(#{full_ur.join(", ")})),4326), geom) ").first["ls"].to_i > 0

        if @debug
          canvas = Magick::Image::read("temp/#{base_name}/#{base_name}_B4.TIF").first
          gc = Magick::Draw.new
        end

        # Enhance contrast on the Landsat 8 images.
        if scene_is_landsat8(base_name)
          channels.each_pair do |c, b|
            `convert ./temp/#{base_name}/#{base_name}_B#{b}.TIF -quiet -level 7%,50%,1.5 -depth 8 ./temp/#{base_name}/#{base_name}_B#{b}_level.TIF`
          end

        #Recalibrate Landsat 4/5/7 images with sun angle/irradiance data.  Fixes red and dark images.
        else
          earthsun_distance = IO.read(File.join(SRC_DIRECTORY, "earthsun_distance.csv")).split("\n")
          sun_elevation = meta_data.select{|a| a.include?("SUN_ELEVATION")}.first.split("=").last.strip.to_f
          d = earthsun_distance.select{|a| a.include?("#{base_name[13..15]},")}.first.split(",").last.strip.to_f
          `python #{File.join(SRC_DIRECTORY, "color_calibration.py")} #{base_name} #{sun_elevation} #{d}`
        end


        puts "Processing #{base_name} data into coastal tiles..."
        tile_data = {}
        no_rows.times do |r|
          no_colls.times do |c|

            # Calculate UTM coords, using the first channel image to extract the coords
            tile_key = "#{r}_#{c}"
            src_file = "./temp/#{base_name}/#{base_name}_B#{channels.values[0]}.TIF"
            pcx = ((image_width * (c+1)/no_colls) + (image_width * c/no_colls)) / 2
            pcy = ((image_height * (r+1)/no_rows) + (image_height * r/no_rows)) / 2
            px0 = image_width * c/no_colls
            px1 = image_width * (c+1)/no_colls
            py0 = image_height * r/no_rows
            py1 = image_height * (r+1)/no_rows
            tile_data[tile_key] = {
              scene: base_name,
              center_utm: get_pixel_coords(src_file, 'utm', pcx, pcy),
              ll_utm: get_pixel_coords(src_file, 'utm', px0, py1),
              ur_utm: get_pixel_coords(src_file, 'utm', px1, py0),
              center_latlng: get_pixel_coords(src_file, 'latlng', pcx, pcy),
              ll_latlng: get_pixel_coords(src_file, 'latlng', px0, py1),
              ur_latlng: get_pixel_coords(src_file, 'latlng', px1, py0),
              utm_zone: get_utm_zone(src_file),
              datum: get_datum(src_file)
            }

            # lower left and upper right for sql test
            ll = tile_data[tile_key][:ll_latlng]
            ur = tile_data[tile_key][:ur_latlng]
            # check aginst coastline
            coastline_intersection = client.exec("select count(*) as ls from coast where ST_Intersects(ST_SetSRID(ST_MakeBox2D(ST_Point(#{ll.join(", ")}), ST_Point(#{ur.join(", ")})),4326), geom) ").first["ls"].to_i > 0

            # does the row/col slice intersect a coastline?
            if coastline_intersection
              target_squares << [r, c]

              if @debug
                gc.fill_opacity("35%")
                gc.stroke("red")
                gc.rectangle( ((r + 1) * image_chunk_width / scale), ((no_colls - c) * image_chunk_height / scale), ((r + 2) * image_chunk_width / scale), ((no_colls - c + 1) * image_chunk_height / scale))
              end

              rr = r + 1
              cc = c
              target_squares << [rr, cc]

              if @debug
                gc.stroke("green")
                gc.rectangle( ((rr + 1) * image_chunk_width / scale), ((no_colls - cc) * image_chunk_height /scale), ((rr + 2) * image_chunk_width / scale), ((no_colls - cc + 1) * image_chunk_height /scale))
              end

              rr = r - 1
              cc = c
              target_squares << [rr, cc]

              if @debug
                gc.stroke("blue")
                gc.rectangle( ((rr + 1) * image_chunk_width / scale), ((no_colls - cc) * image_chunk_height /scale), ((rr + 2) * image_chunk_width / scale), ((no_colls - cc + 1) * image_chunk_height /scale))
              end

              rr = r
              cc = c - 1
              target_squares << [rr, cc]

              if @debug
                gc.stroke("yellow")
                gc.rectangle(((rr + 1) * image_chunk_width / scale), ((no_colls - cc) * image_chunk_height /scale), ((rr + 2) * image_chunk_width / scale), ((no_colls - cc + 1) * image_chunk_height / scale))
              end

              rr = r
              cc = c + 1
              target_squares << [rr, cc]

              if @debug
                gc.stroke("orange")
                gc.rectangle((rr + 1) * image_chunk_width / scale, (no_colls - cc) * image_chunk_height /scale, (rr + 2) * image_chunk_width / scale, (no_colls - cc + 1) * image_chunk_height / scale)
              end
            end
          end
        end

        # Each rejection category gets its own sub folder
        `mkdir -p ./#{sub}/data-products/#{base_name}`
        `mkdir -p ./#{sub}/rejected-data-products/#{base_name}/nowater`
        `mkdir -p ./#{sub}/rejected-data-products/#{base_name}/cloud`

        # Create FF tiles from Landsat scene
        channels_q = Queue.new
        combine_q = Queue.new

        target_squares.uniq.each do |target|
          next if target[0] < 0 or target[1] < 0

          output_file = "./#{sub}/data-products/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"
          channels.each_pair do |c, b|
            channels_q.push({ "channel" => b, "channel_key" => c, "target" => target })
          end

          combine_q.push "convert ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_r.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_g.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_b.png -set colorspace RGB -combine -set colorspace sRGB #{output_file}"
        end

        workers = (0...2).map do
          Thread.new do
            begin
              while opts = channels_q.pop(true)
                b = opts["channel"]
                c = opts["channel_key"]
                target = opts["target"]
                if scene_is_landsat8(base_name)
                  in_file = "./temp/#{base_name}/#{base_name}_B#{b}_level.TIF"
                else
                  in_file = "./temp/#{base_name}/#{base_name}_B#{b}_calibrated.TIF"
                end
                cmd = "convert #{in_file} -quiet -crop #{image_chunk_width}x#{image_chunk_height}+#{image_chunk_width * (target[0])}+#{image_chunk_height * ((no_colls - target[1] - 1))} -resize 532x484 ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_#{c}.png"
                `#{cmd}`
              end
            rescue ThreadError
            end
          end
        end

        workers.map(&:join)

        workers = (0...2).map do
          Thread.new do
            begin
              while cmd = combine_q.pop(true)
                `#{cmd}`
              end
            rescue ThreadError
            end
          end
        end

        workers.map(&:join)

        target_squares.uniq.each do |target|
          next if target[0] < 0 or target[1] < 0

          output_file = "./#{sub}/data-products/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"
          s3_file = "http://zooniverse-data.s3.amazonaws.com/project_data/kelp/#{s3_subfolder}/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"

          blank = File.size(output_file) < 1024 * 6

          # Calculate water/cloud percentages to reject non-coast images
          if !blank
            red_hist = `convert ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_r.png -scale 100x100 -dither None -depth 8 -format %c histogram:info:`
            blank_pixels = `echo "#{red_hist}" | grep -E "gray.0" | cut -d: -f1 | awk '{s+=$1}END{print s}'`
            size = 100 * 100

            # Check for water pixels using rgb bands.  If less than 5% non-blank water pixels, put in rejected manifest.
            begin
              r_water = "([1-9]|([1-2][0-9])|(3[0-5]))" # 1-25
              gb_water = "([1-9]|([1-4][0-9]))" # 1-49
              water_pixels = `convert #{output_file} -scale 100x100 -dither None -depth 8 -format %c histogram:info: | grep -E "#{r_water},#{gb_water},#{gb_water}" | cut -d: -f1 | awk '{s+=$1}END{print s}'`

              #calculate percent of matching non-blank pixels
              water_percent = water_pixels.to_f / (size - blank_pixels.to_f)
              water = water_percent > 0.05
            rescue
              puts "Couldn't read water data"
            end

           # Check for cloud pixels using rgb bands.  If greater than 75% cloud, or no water and greater than 20% cloud, put in rejected manifest.
            begin
              # Cold clouds are dark in the IR band used for red, so use a lower r threshold to catch these as clouds.
              r_range = "(([1-2][0-9][0-9])|([8-9][0-9]))" # >= 80
              gb_range = "([1-2][2-9][0-9])" # >= 100

              cloud_pixels = `convert #{output_file} -scale 100x100 -dither None -depth 8 -format %c histogram:info: | grep -E "#{r_range},#{gb_range},#{gb_range}" | cut -d: -f1 | awk '{s+=$1}END{print s}'`

              #calculate percent of matching non-blank pixels
              cloud_percent = cloud_pixels.to_f / (size - blank_pixels.to_f)
              cloud = cloud_percent > 0.75
            rescue
              puts "Couldn't read cloud data"
            end

            #collect metadata for non-blank images
            r = target[0]
            c = target[1]

            tile_key = "#{target[0]}_#{target[1]}"
            subject_metadata = {
              type: "subject",
              location: s3_file,
              coords: tile_data[tile_key][:center_utm],
              group_name: group_name,
              utm_zone: tile_data[tile_key][:utm_zone],
              datum: tile_data[tile_key][:datum],
              metadata: {
                timestamp: image_time,
                row_no: r,
                col_no: c,
                lower_left: tile_data[tile_key][:ll_utm],
                upper_right: tile_data[tile_key][:ur_utm],
                base_file: base_name,
                no_rows: no_rows,
                no_colls: no_colls,
                file_name: output_file,
                orig_file_name: file_name,
                sun_angle: sun_elevation,
                rejection: {
                  water_percent: water_percent,
                  cloud_percent: cloud_percent
                }
              }
            }

          end

          if blank
            `rm #{output_file}`
          elsif cloud or (!water && cloud_percent > 0.2)
            `mv #{output_file} ./#{sub}/rejected-data-products/#{base_name}/cloud/subject_#{target[0]}_#{target[1]}.jpg`
            subject_metadata[:metadata][:file_name] = "./#{sub}/rejected-data-products/#{base_name}/cloud/subject_#{target[0]}_#{target[1]}.jpg"
            subject_metadata[:metadata][:reject_reason] = "cloud"

            rejected_manifest << subject_metadata

          elsif !water
            `mv #{output_file} ./#{sub}/rejected-data-products/#{base_name}/nowater/subject_#{target[0]}_#{target[1]}.jpg`
            subject_metadata[:metadata][:file_name] = "./#{sub}/rejected-data-products/#{base_name}/nowater/subject_#{target[0]}_#{target[1]}.jpg"
            subject_metadata[:metadata][:reject_reason] = "nowater"

            rejected_manifest << subject_metadata

          else
            manifest << subject_metadata
          end
        end

        if @debug
          gc.draw(canvas)
          canvas.write("./#{sub}/data-products/#{base_name}/overlay.png")
        end

        `rm -rf temp`
      end

      rescue Exception => e
        puts e.message
    end
  end

  File.open("./#{sub}/data-products/manifest.json", "w"){|f| f.puts(JSON.pretty_generate(manifest))}
  File.open("./#{sub}/rejected-data-products/rejected_manifest.json", "w"){|f| f.puts(JSON.pretty_generate(rejected_manifest))}
end
