Floating Forests Data Import
---

This readme is intended to give an overview of the process used to create data for use on http://www.floatingforests.org/. The process tansforms both Landsat 5 and 8 raw scenes into small jpegs suitable for the classification interface.

It's worth noting the scripts were not originally intended to be open-source, and thus should be treated as something more like a guideline on how we did it, rather than a set of ready-to-use scripts for your own processing. Basically, use at your own risk.

Setup database
---

Coastline detection is done via the PostGIS plugin for Postgres. Before beginning, you'll need to have Postgres/PostGIS installed on your machine. I recommend http://postgresapp.com/ for Macs users.

`create database kelp_world;`   
`psql kelp_world < world.pg`

Install gems
`bundle install`

Usage
---

Put any scenes you want to process into the data-files directory.

`ruby create_manifest.rb`   
`ruby create_manifest.rb --debug`

Debug creates an additional overlay image which shows what slices were used. Both dump subject images into the data-products directory.
