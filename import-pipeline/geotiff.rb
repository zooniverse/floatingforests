# Thin wrapper around geotiff.py (ruby-gdal seems to have issues reading GeoTIFFs https://github.com/zhm/gdal-ruby/issues/10)

def get_datum(file)
    return `python #{File.join(SRC_DIRECTORY, 'geotiff.py')} datum #{file}`.tr("\n", "")
end

def get_utm_zone(file)
    return `python #{File.join(SRC_DIRECTORY, 'geotiff.py')} zone #{file}`.tr("\n", "").to_i
end

def get_pixel_coords(file, type, x, y)
    result = `python #{File.join(SRC_DIRECTORY, 'geotiff.py')} pixel2coords #{file} #{type} #{x} #{y}`
    coords = result.tr("(", "").tr(")", "").tr("\n", "").split(",")
    coords = [coords[0].to_f, coords[1].to_f]
end
