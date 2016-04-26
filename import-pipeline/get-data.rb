require 'rubygems'
require 'nokogiri'
require 'thread'
require_relative 'usgs-functions.rb'
require_relative 'process-functions.rb'
require_relative 'api-details.rb'

@s3_subfolder = "testing_pipeline"
@api_key = connect(@usgs_username,@usgs_password)

@places = {
  # "Chicago" => { "latitude" => 41.8369, "longitude" => -87.6847},
  # "Oxford" => { "latitude" => 51.7519, "longitude" => -1.2578},
  # "Dubai" => { "latitude" => 24.9500, "longitude" => 55.3333},
  # "Nishino-Shima" => { "latitude" => 27.2469, "longitude" => 140.8744},
  # "Tangier-Island" => { "latitude" => 37.8258, "longitude" => -75.9922},
  # "Ross" => { "latitude" => -81.5000, "longitude" => -175.0000},
  # "Serengeti" => { "latitude" => -2.3328, "longitude" => 34.5667}
  # "Tangier-Island" => { "latitude" => 37.8258, "longitude" => -75.9922}
  "Tasmania" => { 'north' => -40.4, 'east' => 148.5, 'south' => -43.6, 'west' => 144.5 } #Mainland Tasmania

}

process_q = Queue.new
download_q = Queue.new

@data_directory = ENV.fetch('DATA_DIR', Dir.getwd())
Dir.chdir(@data_directory)

@places.each do |sub, v|
  puts "Locating #{sub} #{v["north"]}, #{v["west"]} to #{v["south"]}, #{v["east"]}"

  ###
  # This block looks like test code to reduce the selected items to a single landsat footprint?

  #items = geo_search(v,"Jan 1 2001","Feb 26 2002")

  #path_freq = items.map{|i| path(i) }.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  #row_freq = items.map{|i| row(i) }.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
  #p_best = items.map{|i| path(i) }.max_by { |v| path_freq[v] }
  #r_best = items.map{|i| row(i) }.max_by { |v| row_freq[v] }

  #new_items = items.select{|i| path(i)==p_best && row(i)==r_best }
  ###

  new_items = geo_search(v)

  scenes = new_items.map{|i| i[:entity_id]}
  datasets = new_items.map{|i| i[:data_access_url][i[:data_access_url].index("?dataset_name=")+14..i[:data_access_url].index("&ordered")-1] }

  # Create subfolder if it doesn't exist
  value = `mkdir -p #{sub}`

  # Process the data
  process_thread = Thread.new do
    begin
      process_data(sub, @s3_subfolder, process_q)
    end
  end

  # Save data to subfolder
  puts "Saving all the #{sub} tiles to the #{sub} folder"
  value = `mkdir -p #{sub}`
  scenes.each_with_index do |scene_id, i|
    download_q.push [scene_id, datasets[i]]
  end

  download_q.push nil

  download_thread = Thread.new do
    while args = download_q.pop
      download_scene(args[0], args[1], sub, process_q, download_q)
    end
  end

  process_q_sent_nil = false

  until download_thread.join(0.2) and process_thread.join(0.2)
    if not process_q_sent_nil and download_q.size == 0
      process_q.push nil
      process_q_sent_nil = true
    end
    print " Downloading #{download_q.size} files; processing #{process_q.size}\r"
    STDOUT.flush
  end

  puts "\nDone!"
end

