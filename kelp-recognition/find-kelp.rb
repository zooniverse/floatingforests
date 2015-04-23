require 'chunky_png'
require 'csv'

# Add neighbours function to Chunky to find similar, connected regions
class ChunkyPNG::Image
	def neighbors(x,y)
	  [[x, y-1], [x+1, y], [x, y+1], [x-1, y]].select do |xy|
	    include_xy?(*xy)
	  end
	end
end

# Traverse the pixels and keep going if they are the same
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

# Function to check if pixel matches the definition of a given type (e.g. Is this pixel cloud, kelp?)
def pixel_is_type(pixel,type)
  if pixel
    g_r = ChunkyPNG::Color.g(pixel)-ChunkyPNG::Color.r(pixel)
    b_g = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.g(pixel)
    b_r = ChunkyPNG::Color.b(pixel)-ChunkyPNG::Color.r(pixel)
    if ( g_r.between?(@types[type][:g_r][0],@types[type][:g_r][1]) && b_g.between?(@types[type][:b_g][0],@types[type][:b_g][1]) && b_r.between?(@types[type][:b_r][0],@types[type][:b_r][1]) )
      if type==:cloud
        return true if ChunkyPNG::Color.r(pixel)>100 && ChunkyPNG::Color.g(pixel)>100 && ChunkyPNG::Color.b(pixel)>100
      else
        return true
      end
    end
  else
    return false
  end
end

# Determine if the x,y region in image is bordered by water
# Returns the fractions of water pixels surounding the area
def waterBorder(image, x, y)

  @border = 10
  @temp = image.dup
  @water_pixels = 0
  @other_pixels = 0

  ((y.min)..(y.max)).each do |y1|
    ((x.min-@border)..(x.min)).each do |x1|
      pixel = @temp[x1,y1] unless x1<=0
      @water_pixels+=1 if pixel_is_type(pixel, :water)
    end
  end

  ((y.min)..(y.max)).each do |y1|
    ((x.max)..(x.max+@border)).each do |x1|
      pixel = @temp[x1,y1] unless x1>=image.width
      @water_pixels+=1 if pixel_is_type(pixel, :water)
    end
  end

  ((x.min)..(x.max)).each do |x1|
    ((y.min-@border)..(y.min)).each do |y1|
      pixel = @temp[x1,y1] unless y1<=0
      @water_pixels+=1 if pixel_is_type(pixel, :water)
    end
  end

  ((x.min)..(x.max)).each do |x1|
    ((y.max)..(y.max+@border)).each do |y1|
      pixel = @temp[x1,y1] unless y1>=image.height
      @water_pixels+=1 if pixel_is_type(pixel, :water)
    end
  end

  water_or_kelp_fraction = @water_pixels.to_f/(@water_pixels+@other_pixels).to_f

end

# Define Kelp, Water and Cloud colours
@types = {
  :water => { :g_r=>[-5,5], :b_g=>[-5,5], :b_r=>[5,50], :col=>[0,100,255] },
  :kelp  => { :g_r=>[5,50], :b_g=>[-40,2], :b_r=>[5,40], :col=>[0,255,0] },
  :cloud => { :g_r=>[-10,10], :b_g=>[-10,10], :b_r=>[-10,10], :col=>[255,255,255] }
}

# Initialise what will become the CSV fles
file_list = [["file","kelp","cloud","water"]]
kelp_list = [["image", "x_min", "x_max", "y_min", "y_max"]]

# Go through all the JPGs in the directory
Dir.glob('*.jpg').each do |image_file|
  zoo_id = File.basename(image_file,".*")
  kelp_found, cloud_found, water_found = false, false, false

  # Get image files and make a working image
  val = `convert #{zoo_id}.jpg #{zoo_id}.png`
  image = ChunkyPNG::Image.from_file("#{zoo_id}.png")
  puts "Inspecting #{zoo_id}"
  rectangles = {}

  # Cycle through the types and record their existence in the rectangles array
  @types.each do |k,v|

    working_image = image.dup
    rectangles[k] = []

    # Create mask
    working_image.pixels.map! do |pixel|
      match = pixel_is_type(pixel, k)
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
      w_k_fraction = waterBorder(image,x,y) if k==:kelp
      if (k==:kelp && w_k_fraction>0.20)
        rectangles[k] << [x.min, y.min, x.max, y.max] if (x.max-x.min)*(y.max-y.min)>=100
        kelp_found=true if (x.max-x.min)*(y.max-y.min)>=100
      else
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
        image.rect(r[0], r[1], r[2], r[3], ChunkyPNG::Color.rgb(@types[k][:col][0],@types[k][:col][1],@types[k][:col][2]))
        kelp_list << [zoo_id, r[0], r[2], r[1], r[3]]
      end
    end
    image.save("#{zoo_id}_kelped.png")
  end

  # Sort out files, clean up temp PNGs
  `convert #{zoo_id}_kelped.png #{zoo_id}_kelped.jpg`
  `rm #{zoo_id}.png`
  `rm #{zoo_id}_kelped.png` if rectangles[:kelp].size>0

end

# Write out the CSV files
CSV.open("file_results.csv", "w") do |csv|
  file_list.each{|l| csv<<l}
end
CSV.open("kelp_results.csv", "w") do |csv|
  kelp_list.each{|l| csv<<l}
end


