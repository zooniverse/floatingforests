require 'rubygems'
require 'savon'
require 'nokogiri'

def connect(u,p)
	
	@client = Savon.client(
	  :wsdl => "https://earthexplorer.usgs.gov/inventory/soap?wsdl",
	  :open_timeout => 30,
	  :read_timeout => 30,
	)

	response = @client.call(:login, message: {
	  username: u,
	  password: p,
	}).to_hash

	return response[:login_response][:return]
end

def path(i)
	i[:summary].index("Path:") ? i[:summary][i[:summary].index("Path: ")+6..i[:summary].index(", Row: ")-1].to_i : i[:summary][i[:summary].index("Path/Row")+10..i[:summary].index(", Coordinates: ")-1].split(",")[0].to_i
end

def row(i)
	i[:summary].index("Path:") ? i[:summary][i[:summary].index("Row: ")+5..-1].to_i : i[:summary][i[:summary].index("Path/Row")+10..i[:summary].index(", Coordinates: ")-1].split(",")[1].to_i
end

def time_search(startDate=(Date.today.to_date-2).strftime('%b %d %Y'),endDate=DateTime.now.strftime('%b %d %Y'))

	# LANDSAT 8
	response_8 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_8",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate
	}).to_hash
	response_8[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_8[:search_response][:return][:results][:item].count} LANDSAT 8 images"

	# LANDSAT 7
	response_7 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_ETM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate
	}).to_hash
	response_7[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_7[:search_response][:return][:results][:item].count} LANDSAT 7 images"

	# LANDSAT 4+5
	response_4_5 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_TM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate
	}).to_hash
	response_4_5[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_4_5[:search_response][:return][:results][:item].count} LANDSAT 4/5 images"

	items = response_4_5[:search_response][:return][:results][:item] + response_7[:search_response][:return][:results][:item] + response_8[:search_response][:return][:results][:item]
	return items

end

def geo_search(lat,lng,size=0.1,startDate="Jan 1 1970",endDate=DateTime.now.strftime('%b %d %Y'))
	
	north=lat+size/2.0
	south=lat-size/2.0
	east=lng+size/2.0
	west=lng-size/2.0

	# LANDSAT 8
	response_8 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_8",
	  apiKey: @api_key,
	  maxResults: 500,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east }
	}).to_hash
	response_8[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_8[:search_response][:return][:results][:item].count} LANDSAT 8 images"

	# LANDSAT 7
	response_7 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_ETM",
	  apiKey: @api_key,
	  maxResults: 500,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east }
	}).to_hash
	response_7[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_7[:search_response][:return][:results][:item].count} LANDSAT 7 images"

	# LANDSAT 4+5
	response_4_5 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_TM",
	  apiKey: @api_key,
	  maxResults: 500,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east }
	}).to_hash
	response_4_5[:search_response][:return][:results][:item] ||= []
	puts "Found #{response_4_5[:search_response][:return][:results][:item].count} LANDSAT 4/5 images"

	items = response_4_5[:search_response][:return][:results][:item] + response_7[:search_response][:return][:results][:item] + response_8[:search_response][:return][:results][:item]
	return items

end

@api_key = connect("kyleccav","zooniverse1")

	# "Chicago" => { "latitude" => 41.8369, "longitude" => -87.6847},
	# "Oxford" => { "latitude" => 51.7519, "longitude" => -1.2578},
	# "Dubai" => { "latitude" => 24.9500, "longitude" => 55.3333},
	# "Nishino-Shima" => { "latitude" => 27.2469, "longitude" => 140.8744},
	# "Tangier-Island" => { "latitude" => 37.8258, "longitude" => -75.9922},
	# "Ross" => { "latitude" => -81.5000, "longitude" => -175.0000},
	# "Serengeti" => { "latitude" => -2.3328, "longitude" => 34.5667}

places = {
	"Tangier-Island" => { "latitude" => 37.8258, "longitude" => -75.9922}
}

places.each do |sub, v|

	puts "Processing #{sub} at #{v["latitude"]}, #{v["longitude"]}"
	items = geo_search(v["latitude"],v["longitude"])

	path_freq = items.map{|i| path(i) }.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	row_freq = items.map{|i| row(i) }.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	p_best = items.map{|i| path(i) }.max_by { |v| path_freq[v] }
	r_best = items.map{|i| row(i) }.max_by { |v| row_freq[v] }

	new_items = items.select{|i| path(i)==p_best && row(i)==r_best }

	summaries = new_items.map{|i| i[:summary]}
	thumbnails = new_items.map{|i| i[:browse_url]}
	scenes = new_items.map{|i| i[:entity_id]}
	dates = new_items.map{|i| i[:acquisition_date]}

	# Save images to subfolder
	puts "Saving all the #{sub} image files to the #{sub} folder"
	value = `mkdir -p #{sub}`
	thumbnails.each_with_index do |url, i|
		value = `wget -O #{sub}/#{dates[i].strftime("%Y%m%d-%H%M%S")}.jpg #{url} -nv &`
	end

	# Make contact sheets
	puts "Creating image file thumbnails_#{sub}.png"
	cmd = "montage #{sub}/*.jpg -geometry 200x200+0+0 #{sub}/contact.png"
	value = `#{cmd}`

	# Make movie preview
	puts "Creating the movie file movie_#{sub}.mp4"
	cmd = "convert #{sub}/*.jpg #{sub}/movie.mp4"
	value = `#{cmd}`

end

# List Datasets
# response = client.call(:datasets, message: {
#   node: "EE",
#   startDate: "Feb 8 1970"
# }).to_hash
# items = response[:datasets_response][:return][:item]
# datasets = items.map{|i| i[:dataset_name]}

# List Dataset fields
# response = client.call(:dataset_fields, message: {
#   node: "EE",
#   datasetName: "LANDSAT_8",
#   apiKey: api_key
# }).to_hash
# items = response[:dataset_fields_response][:return][:item]
# fields = items.map{|i| i[:name]}

