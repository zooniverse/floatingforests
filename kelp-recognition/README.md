Automatic Kelp Recognition
---

This is attempt to reduce the overall volume of data needed to be process by Floating Forests (www.floatingforests.org).

What This Does
---

The script takes all the JPGs in the directory and searches them for kelp. If it finds any, it creates a filename*_kelped*.jpg version. It works on temporary PNG duplicates of the JPGs, so they will not be altered.

The script scans each image's pixels for contiguous regions of kelp-colour. When it finds such pixels, it checks to see if they are bordered by water-coloured pixels. If they are, these regions are recorded as kelp in *kelp_results.csv* and marked on the *_kelped* images in green.

All files are checked for kelp, water, and cloud. True/false values for each are recorded in *file_results.csv*.

Simplistically, you can adjust the *@types* hash in the script, which changes the definition of the colours of cloud, water, and kelp.


Usage and Requirements
---
You'll need a recent Ruby version and the ChuknyPNG gem (chunky_png).

`ruby find-kelp.rb` will start going through any JPGs. Be sure to remove previous *_kelped* files before running the script to avoid endless *_kelped_kelped* files forming.