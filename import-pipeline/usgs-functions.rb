require 'savon'
require 'httparty'

@cloud_limit = 4

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
	  endDate: endDate,
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 10037,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r8 = response_8[:search_response][:return][:results][:item] ||= []
	r8 = r8.kind_of?(Array) ? r8 : [r8]
	puts "Found #{r8.count} LANDSAT 8 images"

	# LANDSAT 7
	response_7 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_ETM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate,
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 3949,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r7 = response_7[:search_response][:return][:results][:item] ||= []
	r7 = r7.kind_of?(Array) ? r7 : [r7]
	puts "Found #{r7.count} LANDSAT 8 images"

	# LANDSAT 4+5
	response_4_5 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_TM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate,
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 3653,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r4_5 = response_4_5[:search_response][:return][:results][:item] ||= []
	r4_5 = r4_5.kind_of?(Array) ? r4_5 : [r4_5]
	puts "Found #{r4_5.count} LANDSAT 4/5 images"

		items = r4_5 + r7 + r8
	return items

end

def geo_search(lat,lng,startDate="Jan 1 1970",endDate=DateTime.now.strftime('%b %d %Y'),size=0.1)
	
	north=lat+size/2.0
	south=lat-size/2.0
	east=lng+size/2.0
	west=lng-size/2.0

	# LANDSAT 8
	response_8 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_8",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east },
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 10037,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r8 = response_8[:search_response][:return][:results][:item] ||= []
	r8 = r8.kind_of?(Array) ? r8 : [r8]
	puts "Found #{r8.count} LANDSAT 8 images"

	# LANDSAT 7
	response_7 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_ETM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east },
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 3949,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r7 = response_7[:search_response][:return][:results][:item] ||= []
	r7 = r7.kind_of?(Array) ? r7 : [r7]
	puts "Found #{r7.count} LANDSAT 7 images"

	# LANDSAT 4+5
	response_4_5 = @client.call(:search, message: {
	  node: "EE",
	  datasetName: "LANDSAT_TM",
	  apiKey: @api_key,
	  maxResults: 5000,
	  startDate: startDate,
	  endDate: endDate,
	  lowerLeft: { latitude: south, longitude: west },
	  upperRight: { latitude: north, longitude: east },
	  additionalCriteria: {
	  	filterType: "between",
	  	fieldId: 3653,
	  	firstValue: "0",
	  	secondValue: "#{@cloud_limit}"
	  }
	}).to_hash
	r4_5 = response_4_5[:search_response][:return][:results][:item] ||= []
	r4_5 = r4_5.kind_of?(Array) ? r4_5 : [r4_5]
	puts "Found #{r4_5.count} LANDSAT 4/5 images"

	items = r4_5 + r7 + r8
	return items

end

def request_scene(scene_id,dataset)
	response = @client.call(:download_options, message: {
	  node: "EE",
	  datasetName: dataset,
	  apiKey: @api_key,
	  entityId: scene_id
	}).to_hash
	files = response[:download_options_response][:return][:item][:download_options][:item]
	geoTIFF_file = files.select{|f| f[:download_code]=="STANDARD"}
	return geoTIFF_file[0][:url] ||= "Not available"
end

def download_scene(scene_id,dataset,sub)
	url = URI.encode('https://earthexplorer.usgs.gov/inventory/json/download?jsonRequest={"datasetName":"'+dataset+'","products":["STANDARD"],"entityIds":["'+scene_id+'"],"apiKey":"'+@api_key+'","node":"EE"}')
	response = HTTParty.get(url)
	files = response.parsed_response["data"]
	# Check that file have been returned
	if files[0]
		# Check if files have already been downloaded
		if File.exist?("#{sub}/#{File.basename(URI(files[0]).path)}")
			puts "#{File.basename(URI(files[0]).path)} already downloaded"
			return
		else
			puts "#{File.basename(URI(files[0]).path)} downloading..."
			value = `wget -O #{sub}/#{File.basename(URI(files[0]).path)} '#{files[0]}' &`
			return
		end
	else
		puts "Error: "+response.parsed_response["error"] 
	end
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
