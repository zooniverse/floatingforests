#!/usr/bin/env ruby
 
 require 'base64'
 require 'json'
 require 'rest_client'
 
 # Set the request parameters
 host = 'https://earthexplorer.usgs.gov'
 user = 'kyleccav'
 pwd = 'zooniverse1'
 
 request_body_map = {
   :username => 'kyleccav',
   :password => 'zooniverse1'
 }
 
 begin
   response = RestClient.post("#{host}/inventory/json/login",
                              {:jsonRequest=>request_body_map}.to_json,    # Encode the entire body as JSON
                              {:authorization => "Basic #{Base64.strict_encode64("#{user}:#{pwd}")}",
                               :content_type => 'application/json',
                               :accept => 'application/json'}
                             )
   puts "#{response.to_str}"
   puts "Response status: #{response.code}"
   response.headers.each { |k,v|
     puts "Header: #{k}=#{v}"
   }
 
 rescue => e
   puts "ERROR: #{e}"
 end