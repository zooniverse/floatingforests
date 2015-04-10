require 'pg'
require 'RMagick'
require 'json'
require 'date'

@debug = ARGV[0] == '--debug'

def process_data(sub, s3_subfolder)
  
  group_name = s3_subfolder

  client = PG.connect(dbname: "kelp_world")

  no_rows  = 20
  no_colls = 20

  image_width  = 7981
  image_height = 7271

  scale = 1.0

  image_chunk_width = image_width / no_rows
  image_chunk_height = image_height / no_colls

  target_squares = []

  manifest = []
  rejected_manifest = []
  
  lc8_channels = {r:6 , g:5 , b:4}
  other_channels = {r:5 , g:4 , b:3}
  

  Dir.glob("#{sub}/*").each_with_index do |raw_scene, index|
    begin
      file_name = File.basename(raw_scene)
      base_name = File.basename(raw_scene, ".tar.gz")

      `mkdir -p temp/#{base_name}`
      puts "\n##########\nExtracting data from #{file_name}"
      `tar -xzvf #{raw_scene} -C temp/#{base_name}`
      
      if base_name[0..2] == "LC8"
        channels = lc8_channels
      else
        channels = other_channels
      end

      if @debug
        canvas = Magick::Image::read("temp/#{base_name}/#{base_name}_B4.TIF").first
      end
      
      meta_data = IO.read("temp/#{base_name}/#{base_name}_MTL.txt").split("\n")
      
      earthsun_distance = IO.read("earthsun_distance.csv").split("\n")
      
      # Enhance contrast on the Landsat 8 images.  If this starts outputting images with weird colours, it can be modified to combine the bands, enhance contrast, and then split them again.  It's expensive to do that, and in testing all the images came out normal processing them separately.  
      if base_name[0..2] == "LC8"
        channels.each_pair do |c, b|
          `convert ./temp/#{base_name}/#{base_name}_B#{b}.TIF -quiet -level 7%,50%,1.5 -depth 8 ./temp/#{base_name}/#{base_name}_B#{b}_level.TIF`
          `rm ./temp/#{base_name}/#{base_name}_B#{b}.TIF`
          `mv ./temp/#{base_name}/#{base_name}_B#{b}_level.TIF ./temp/#{base_name}/#{base_name}_B#{b}.TIF`
        end
        
      #Recalibrate Landsat 4/5/7 images with sun angle/irradiance data.  Fixes red and dark images.
      else
        sun_elevation = meta_data.select{|a| a.include?("SUN_ELEVATION")}.first.split("=").last.strip.to_f
        d = earthsun_distance.select{|a| a.include?("#{base_name[13..15]},")}.first.split(",").last.strip.to_f
        `python3 color_calibration.py #{base_name} #{sun_elevation} #{d}`
      end

      lat_long = meta_data.select{|a| a.include?("CORNER_UR_L") || a.include?("CORNER_LL_L")}.inject({}){|r,l| kv = l.split("=").collect{|l| l.strip}; r[kv[0]] = kv[1].to_f; r}
      date = meta_data.select{|a| a.include?("DATE_ACQUIRED")}.first.split("=").last.strip
      time = meta_data.select{|a| a.include?("SCENE_CENTER_TIME")}.first.split("=").last.strip

      image_time = DateTime.parse(date + " " + time)

      full_ll = [lat_long["CORNER_LL_LON_PRODUCT"], lat_long["CORNER_LL_LAT_PRODUCT"]]
      full_ur = [lat_long["CORNER_UR_LON_PRODUCT"], lat_long["CORNER_UR_LAT_PRODUCT"]]

      lon_inc = (full_ll[0] - full_ur[0]) / no_rows
      lat_inc = (full_ll[1] - full_ur[1]) / no_colls

      if @debug
        gc = Magick::Draw.new
      end

      puts "\n##########\nProcessing #{base_name} data into coastal tiles..."
      no_rows.times do |r|
        no_colls.times do |c|
          lon_center = (r + 0.5) * lon_inc + full_ll[0]
          lat_center = (c + 0.5) * lat_inc + full_ll[1]

          # lower left and upper right
          ll =  [full_ll[0] + (full_ur[0] - full_ll[0]) * r / no_rows, full_ll[1] + (full_ur[1] - full_ll[1]) * c / no_colls]
          ur =  [full_ll[0] + (full_ur[0] - full_ll[0]) * (r + 1) / no_rows, full_ll[1] + (full_ur[1] -full_ll[1]) * (c + 1) / no_colls]

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

      # Each rejection category gets it's own sub folder, in case there are more in the future.
      `mkdir -p ./#{sub}/data-products/#{base_name}`
      `mkdir -p ./#{sub}/rejected-data-products/#{base_name}/nowater`
      `mkdir -p ./#{sub}/rejected-data-products/#{base_name}/cloud`

      target_squares.uniq.each do |target|
        next if target[0] < 0 or target[1] < 0

        ####
        ## This is where the colours get checked and combined - maybe redness is here?
        ####
        channels.each_pair do |c, b|
          `convert ./temp/#{base_name}/#{base_name}_B#{b}.TIF -quiet -crop #{image_chunk_width}x#{image_chunk_height}+#{image_chunk_width * (target[0])}+#{image_chunk_height * ((no_colls - target[1] - 1))} -resize 532x484 ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_#{c}.png`
        end

        output_file = "./#{sub}/data-products/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"
        s3_file = "http://zooniverse-data.s3.amazonaws.com/project_data/kelp/#{s3_subfolder}/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"

        `convert ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_r.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_g.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_b.png -set colorspace RGB -combine -set colorspace sRGB #{output_file}`
        
        blank = File.size(output_file) < 1024 * 6
        
        # Don't bother calculating pixel values on blank images
        if !blank
          # blank pixels are used in all cuts, calculate them once
          red_hist = `convert ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_r.png -scale 100x100 -dither None -depth 8 -format %c histogram:info:`  
          blank_pixels = `echo "#{red_hist}" | grep -E ",\s+0,\s"  | cut -d: -f1 | awk '{s+=$1}END{print s}'`
          
          # Check for water pixels using the red band.  If less than 5% non-blank water pixels, put in rejected manifest.
          begin
            #Water is vaule 1-25 in the red band.  Select and sum.
            size = 100 * 100
            water_pixels = `echo "#{red_hist}" | grep -E ",\s+([1-9]|([1-2][0-9])),\s" | cut -d: -f1 | awk '{s+=$1}END{print s}'`
            #calculate percent of matching non-blank pixels
            water_percent = water_pixels.to_f / (size - blank_pixels.to_f)
            
            water = water_percent > 0.05
          rescue
            puts "Couldn't read water data"
          end
          
         # Check for cloud pixels using rgb bands.  If greater than 75% cloud, put in rejected manifest.
          begin
            # Cold clouds are dark in the IR band used for red, so use a lower r threshold to catch these as clouds.
            r_range = "(([1-2][0-9][0-9])|([8-9][0-9]))" # > 80
            gb_range = "((2[0-9][0-9])|(1[2-9][0-9]))" # > 120
            size = 100 * 100
            cloud_pixels = `convert #{output_file} -scale 100x100 -dither None -depth 8 -format %c histogram:info: | grep -E "#{r_range},#{gb_range},#{gb_range}" | cut -d: -f1 | awk '{s+=$1}END{print s}'`  
            cloud_percent = cloud_pixels.to_f / (size - blank_pixels.to_f)
            cloud = cloud_percent > 0.75
          rescue
            puts "Couldn't read dominant colour"
          end
          
          #collect metadata for non-blank images
          r = target[0]
          c = target[1]

          ll = [full_ll[0] + (full_ur[0] - full_ll[0]) * r / no_rows, full_ll[1] + (full_ur[1] - full_ll[1]) * c / no_colls]
          ur = [full_ll[0] + (full_ur[0] - full_ll[0]) * (r + 1) / no_rows, full_ll[1] + (full_ur[1] -full_ll[1]) * (c + 1) / no_colls]
        
          subject_metadata = {
            type: "subject",
            location: s3_file,
            coords: [(ll[0] + ur[0]) * 0.5, (ll[1] + ur[1]) * 0.5],
            group_name: group_name,
            metadata: {
              timestamp: image_time,
              row_no: r,
              col_no: c,
              lower_left: ll,
              upper_right: ur,
              base_file: base_name,
              no_rows: no_rows,
              no_colls: no_colls,
              file_name: output_file,
              orig_file_name: file_name,
              rejection: {
                water_percent: water_percent,
                cloud_percent: cloud_percent
              }
            }
          }
          
        end
        
        if blank 
          `rm #{output_file}`
        elsif cloud or (!water && cloud_percent > 0.25)
          puts "Clouded image w: #{water_percent}% c: #{cloud_percent}% #{output_file} - skipping"
          `mv #{output_file} ./#{sub}/rejected-data-products/#{base_name}/cloud/subject_#{target[0]}_#{target[1]}.jpg`
          subject_metadata[:metadata][:file_name] = "./#{sub}/rejected-data-products/#{base_name}/cloud/subject_#{target[0]}_#{target[1]}.jpg"
          subject_metadata[:metadata][:reject_reason] = "cloud"
          
          rejected_manifest << subject_metadata
          
        elsif !water
          puts "No water in image w: #{water_percent}% c: #{cloud_percent}% #{output_file} - skipping"
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
    rescue Exception => e
      puts e.message
    end
  end

  File.open("./#{sub}/data-products/manifest.json", "w"){|f| f.puts(JSON.pretty_generate(manifest))}
  File.open("./#{sub}/rejected-data-products/rejected_manifest.json", "w"){|f| f.puts(JSON.pretty_generate(rejected_manifest))}

end
