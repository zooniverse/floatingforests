Floating Forests Data Pipeline
---

This readme is intended to give an overview of the process used to create data for use on http://www.floatingforests.org/. The process tansforms both Landsat 4/5, 7 and 8 raw scenes into small jpegs suitable for the classification interface.

It's worth noting the scripts were not originally intended to be open-source, and thus should be treated as something more like a guideline on how we did it, rather than a set of ready-to-use scripts for your own processing. Basically, use at your own risk.

The coastline detection and image-splicing was created by Chris Snyder, the USGS (LANDSAT) API functions and some modifications as by Robert Simpson.

ImageMagick, PostGres 
---

All need to be working. I recommend Homebrew for Imagemagick. I recommend http://postgresapp.com/ for Macs users.

Setup database
---

Coastline detection is done via the PostGIS plugin for Postgres. Before beginning, you'll need to have Postgres/PostGIS installed on your machine. See above.

`create database kelp_world;`   
`psql kelp_world < world.pg`

Install gems
`bundle install`

Usage
---

Create a api-details.rb file with correct USGS username and password. See -example file.

Modify the @places hash in the get-data.rb script to point it at the required lat/long and region. Then run

`ruby get-data.rb`

It will create subdirectories for the created data and directories within each location for the LANDSAT scenes.

It will then process the downloaded data and create a Zooniverse manifest.json file, ready for upload to S3.

Example Docker usage:

```
docker run -it --rm -v /data/:/data/ -e "DATA_DIR=/data/" -v $PWD/config/api-details.rb:/src/api-details.rb zooniverse/kelp-import-pipeline ruby get-data.rb
```

Future Improvements
---

kelp-recognition.rb still seems to think some clouds are kelp.

Use a different method for cloud detection in the get-data.rb script? (possibly check out the kelp-recongnition code).

