require 'pg'
require 'RMagick'
require 'json'
require 'date'

debug = ARGV[0] == '--debug'
client = PG.connect(dbname: "kelp_world")
s3_subfolder = "tasmania"
group_name = s3_subfolder

no_rows  = 20
no_colls = 20

image_width  = 7981
image_height = 7271

scale = 1.0

image_chunk_width = image_width / no_rows
image_chunk_height = image_height / no_colls

target_squares = []

manifest = []
lc8_channels = {r:6 , g:5 , b:4}
other_channels = {r:5 , g:4 , b:3}

Dir.glob("data-files/*").each_with_index do |raw_scene, index|
  begin
    file_name = File.basename(raw_scene)
    base_name = File.basename(raw_scene, ".tar.bz")

    `mkdir -p temp/#{base_name}`
    `tar -xzvf #{raw_scene} -C temp/#{base_name}`

    if debug
      canvas = Magick::Image::read("temp/#{base_name}/#{base_name}_B4.TIF").first
    end

    meta_data = IO.read("temp/#{base_name}/#{base_name}_MTL.txt").split("\n")

    lat_long = meta_data.select{|a| a.include?("CORNER_UR_L") || a.include?("CORNER_LL_L")}.inject({}){|r,l| kv = l.split("=").collect{|l| l.strip}; r[kv[0]] = kv[1].to_f; r}
    date = meta_data.select{|a| a.include?("DATE_ACQUIRED")}.first.split("=").last.strip
    time = meta_data.select{|a| a.include?("SCENE_CENTER_TIME")}.first.split("=").last.strip

    image_time = DateTime.parse(date + " " + time)

    full_ll = [lat_long["CORNER_LL_LON_PRODUCT"], lat_long["CORNER_LL_LAT_PRODUCT"]]
    full_ur = [lat_long["CORNER_UR_LON_PRODUCT"], lat_long["CORNER_UR_LAT_PRODUCT"]]

    lon_inc = (full_ll[0] - full_ur[0]) / no_rows
    lat_inc = (full_ll[1] - full_ur[1]) / no_colls

    if debug
      gc = Magick::Draw.new
    end

    puts "Processing #{base_name}..."
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

          if debug
            gc.fill_opacity("35%")
            gc.stroke("red")
            gc.rectangle((r + 1) * image_chunk_width / scale, (no_colls - c) * image_chunk_height / scale, (r + 2) * image_chunk_width / scale, (no_colls - c + 1) * image_chunk_height / scale)
          end

          rr = r + 1
          cc = c
          target_squares << [rr, cc]

          if debug
            gc.stroke("green")
            gc.rectangle((rr + 1) * image_chunk_width / scale, (no_colls - cc) * image_chunk_height /scale, (rr + 2) * image_chunk_width / scale, (no_colls - cc + 1) * image_chunk_height /scale)
          end

          rr = r - 1
          cc = c
          target_squares << [rr, cc]

          if debug
            gc.stroke("blue")
            gc.rectangle((rr + 1) * image_chunk_width / scale, (no_colls - cc) * image_chunk_height /scale, (rr + 2) * image_chunk_width / scale, (no_colls - cc + 1) * image_chunk_height /scale)
          end

          rr = r
          cc = c - 1
          target_squares << [rr, cc]

          if debug
            gc.stroke("yellow")
            gc.rectangle((rr + 1) * image_chunk_width / scale, (no_colls - cc) * image_chunk_height /scale, (rr + 2) * image_chunk_width / scale, (no_colls - cc + 1) * image_chunk_height / scale)
          end

          rr = r
          cc = c + 1
          target_squares << [rr, cc]

          if debug
            gc.stroke("orange")
            gc.rectangle((rr + 1) * image_chunk_width / scale, (no_colls - cc) * image_chunk_height /scale, (rr + 2) * image_chunk_width / scale, (no_colls - cc + 1) * image_chunk_height / scale)
          end
        end
      end
    end

    `mkdir -p data-products/#{base_name}`

    target_squares.uniq.each do |target|
      next if target[0] < 0 or target[1] < 0

      if base_name[0..2] == "LC8"
        channels = lc8_channels
      else
        channels = other_channels
      end

      channels.each_pair do |c, b|
        `convert ./temp/#{base_name}/#{base_name}_B#{b}.TIF -quiet -crop #{image_chunk_width}x#{image_chunk_height}+#{image_chunk_width * (target[0])}+#{image_chunk_height * ((no_colls - target[1] - 1))} -resize 532x484 ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_#{c}.png`
      end

      output_file = "./data-products/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"
      s3_file = "http://zooniverse-data.s3.amazonaws.com/project_data/kelp/#{s3_subfolder}/#{base_name}/subject_#{target[0]}_#{target[1]}.jpg"

      `convert ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_r.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_g.png ./temp/#{base_name}/coast_#{target[0]}_#{target[1]}_b.png -set colorspace RGB -combine -set colorspace sRGB #{output_file}`

      blank = File.size(output_file) < 1024 * 6
      if blank
        `rm #{output_file}`
      else
        r = target[0]
        c = target[1]

        ll = [full_ll[0] + (full_ur[0] - full_ll[0]) * r / no_rows, full_ll[1] + (full_ur[1] - full_ll[1]) * c / no_colls]
        ur = [full_ll[0] + (full_ur[0] - full_ll[0]) * (r + 1) / no_rows, full_ll[1] + (full_ur[1] -full_ll[1]) * (c + 1) / no_colls]

        manifest << {
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
            orig_file_name: file_name
          }
        }
      end
    end

    if debug
      gc.draw(canvas)
      canvas.write("./data-products/#{base_name}/overlay.png")
    end

    `rm -rf temp`
  rescue Exception => e
    puts e.message
  end
end

File.open("./data-products/manifest.json", "w"){|f| f.puts(JSON.pretty_generate(manifest))}
