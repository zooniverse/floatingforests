require 'chunky_png'
require 'csv'

class ChunkyPNG::Image
	def neighbors(x,y)
	  [[x, y-1], [x+1, y], [x, y+1], [x-1, y]].select do |xy|
	    include_xy?(*xy)
	  end
	end
end

def label_recursively(image, areas, label, x, y, depth=0)
  image[x,y] = label
  (areas[label] ||= []) << [x,y]

  image.neighbors(x,y).each do |xy|
    if image[*xy] == -1
      areas[label] << xy
      label_recursively(image, areas, label, *xy, depth+=1) unless depth==2048
    end
  end
end

def kelpPixel(pixel, types)
  if pixel
    g_r = ChunkyPNG::Color.g(pixel)-ChunkyPNG::Color.r(pixel)
    b_g = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.g(pixel)
    b_r = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.r(pixel)
    return true if ( g_r<=types[:kelp][:g_r] && b_g<=types[:kelp][:b_g] && b_r<=types[:kelp][:b_r] )
  else
    return false
  end
end

def waterPixel(pixel, types, center)
  if pixel
    g_r = ChunkyPNG::Color.g(pixel)-ChunkyPNG::Color.r(pixel)
    b_g = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.g(pixel)
    b_r = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.r(pixel)
    return true if ( g_r<=types[:water][:g_r] && b_g<=types[:water][:b_g] && b_r<=types[:water][:b_r] ) # && (ChunkyPNG::Color.g(pixel)-ChunkyPNG::Color.g(center))>=5
  else
    return false
  end
end

def waterBorder(image, x, y, types)
  
  @border = 10
  @temp = image.dup
  @water_pixels = 0
  @kelp_pixels = 0
  @other_pixels = 0

  @midPixel = pixel = @temp[((x.max-x.min)/2),((y.max-y.min)/2)]

  ((y.min)..(y.max)).each do |y1|
    ((x.min-@border)..(x.min)).each do |x1|
      pixel = @temp[x1,y1] unless x1<=0
      water = waterPixel(pixel, types, @midPixel)
      kelp = kelpPixel(pixel, types)
      if water==true
        @water_pixels+=1
      else
        kelp==true ? @kelp_pixels+=1 : @other_pixels+=1
      end
    end
  end

  ((y.min)..(y.max)).each do |y1|
    ((x.max)..(x.max+@border)).each do |x1|
      pixel = @temp[x1,y1] unless x1>=image.width
      water = waterPixel(pixel, types, @midPixel)
      kelp = kelpPixel(pixel, types)
      if water==true
        @water_pixels+=1
      else
        kelp==true ? @kelp_pixels+=1 : @other_pixels+=1
      end
    end
  end

  ((x.min)..(x.max)).each do |x1|
    ((y.min-@border)..(y.min)).each do |y1|
      pixel = @temp[x1,y1] unless y1<=0
      water = waterPixel(pixel, types, @midPixel)
      kelp = kelpPixel(pixel, types)
      if water==true
        @water_pixels+=1
      else
        kelp==true ? @kelp_pixels+=1 : @other_pixels+=1
      end
    end
  end

  ((x.min)..(x.max)).each do |x1|
    ((y.max)..(y.max+@border)).each do |y1|
      pixel = @temp[x1,y1] unless y1>=image.height
      water = waterPixel(pixel, types, @midPixel)
      kelp = kelpPixel(pixel, types)
      if water==true
        @water_pixels+=1
      else
        kelp==true ? @kelp_pixels+=1 : @other_pixels+=1
      end
    end
  end

  water_or_kelp_fraction = (@water_pixels.to_f+@kelp_pixels.to_f)/(@water_pixels+@other_pixels+@kelp_pixels).to_f

end

file_list = [["file","kelp","cloud","water"]]
kelp_list = [["image", "x_min", "x_max", "y_min", "y_max"]]

Dir.glob('*.jpg').each do |image_file|
  zoo_id = File.basename(image_file,".*")
  kelp_found, cloud_found, water_found = false, false, false
  # zoo_id="subject_9_13"

  # Get image files and make a working image
  val = `convert #{zoo_id}.jpg #{zoo_id}.png`
  image = ChunkyPNG::Image.from_file("#{zoo_id}.png")
  puts "Inspecting #{zoo_id}"
  rectangles = {}

  types = {
    :water => { :r=>[35,70], :g=>[0,60], :b=>[50,150], :g_r=>10, :b_g=>10, :b_r=>25, :col=>[0,100,255] },
    :kelp  => { :r=>[0,55],  :g=>[60,255], :b=>[60,90], :g_r=>100, :b_g=>10, :b_r=>40, :col=>[0,255,0] },
    :cloud => { :r=>[180,255], :g=>[180,255], :b=>[180,255], :g_r=>10, :b_g=>10, :b_r=>10, :col=>[255,255,255] }
  }

  types.each do |k,v|

    working_image = image.dup
    rectangles[k] = []

    # Create mask
    working_image.pixels.map! do |pixel|
      match = true if ( ChunkyPNG::Color.g(pixel).between?(v[:g][0],v[:g][1]) && ChunkyPNG::Color.r(pixel).between?(v[:r][0],v[:r][1]) && ChunkyPNG::Color.b(pixel).between?(v[:b][0],v[:b][1]) )
      match ? -1 : 0
    end

    areas, label = {}, 0

    working_image.height.times do |y|
      working_image.row(y).each_with_index do |pixel, x|
        label_recursively(working_image, areas, label += 1, x, y) if pixel == -1
      end
    end

    puts "Found #{areas.values.size} #{k.to_s} regions"

    # Go through regions and record them in the rectangles list
    areas.values.each do |area|
      x, y = area.map{ |xy| xy[0] }, area.map{ |xy| xy[1] }
      w_k_fraction = waterBorder(image,x,y,types) if k==:kelp
      if (k==:kelp && w_k_fraction>0.2)
        rectangles[k] << [x.min, y.min, x.max, y.max]
        kelp_found=true
      else
        # rectangles[k] << [x.min, y.min, x.max, y.max] if ( (k==:water || k==:clouds) && (x.max-x.min)*(y.max-y.min)>=400)
        rectangles[k] << [x.min, y.min, x.max, y.max] if ( k==:clouds && (x.max-x.min)*(y.max-y.min)>=400)
        cloud_found=true if ( k==:clouds && (x.max-x.min)*(y.max-y.min)>=400)
        water_found=true if ( k==:water && (x.max-x.min)*(y.max-y.min)>=400)
      end
    end

  end

  file_list << [zoo_id, kelp_found, cloud_found, water_found]

  # Create output images by drawing all the rectangles
  if rectangles[:kelp].size>0
    rectangles.each do |k,list|
      list.each do |r|
        image.rect(r[0], r[1], r[2], r[3], ChunkyPNG::Color.rgb(types[k][:col][0],types[k][:col][1],types[k][:col][2]))
        kelp_list << [zoo_id, r[0], r[2], r[1], r[3]]
      end
    end
    image.save("#{zoo_id}_kelped.png")
  end

  # Sort out files
  `convert #{zoo_id}_kelped.png #{zoo_id}_kelped.jpg`
  `rm #{zoo_id}.png`
  `rm #{zoo_id}_kelped.png` if rectangles[:kelp].size>0

end

CSV.open("file_results.csv", "w") do |csv|
  file_list.each{|l| csv<<l}
end

CSV.open("kelp_results.csv", "w") do |csv|
  kelp_list.each{|l| csv<<l}
end


