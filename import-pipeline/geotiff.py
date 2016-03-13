import sys
import gdal
import osr
import ogr

def get_proj4(ds):
    # Get proj4 string
    src = osr.SpatialReference()
    src.ImportFromWkt(ds.GetProjection())
    return src.ExportToProj4()

def get_proj_param(ds, param):
    # Get proj4 string
    src = osr.SpatialReference()
    src.ImportFromWkt(ds.GetProjection())
    # Extract and return required param's value
    return filter(lambda v: v.find("+"+param+"=") > -1, src.ExportToProj4().split(" "))[0].replace("+"+param+"=", "")

def get_datum(ds):
    return get_proj_param(ds, "datum")

def get_utm_zone(ds):
    return get_proj_param(ds, "zone")

def get_pixel_coords_latlng(ds, px, py, datum):
    # Get coordinate system from file
    in_cs= osr.SpatialReference()
    in_cs.ImportFromWkt(ds.GetProjectionRef())

    # Create WGS84 coord system for latlngs
    wgs84_wkt = """
    GEOGCS["WGS 84",
        DATUM["WGS_1984",
            SPHEROID["WGS 84",6378137,298.257223563,
                AUTHORITY["EPSG","7030"]],
            AUTHORITY["EPSG","6326"]],
        PRIMEM["Greenwich",0,
            AUTHORITY["EPSG","8901"]],
        UNIT["degree",0.01745329251994328,
            AUTHORITY["EPSG","9122"]],
        AUTHORITY["EPSG","4326"]]"""
    out_cs = osr.SpatialReference()
    out_cs .ImportFromWkt(wgs84_wkt)

    # Create point with required x,y
    xy_utm = get_pixel_coords_utm(ds, px, py)
    point = ogr.Geometry(ogr.wkbPoint)
    point.AddPoint(xy_utm[0], xy_utm[1])

    # Transform point from UTM to latlng
    coord_transform = osr.CoordinateTransformation(in_cs, out_cs)
    point.Transform(coord_transform)

    # Return point as list
    return point.GetX(), point.GetY()


def get_pixel_coords_utm(ds, px, py):
    # Get file dimensions
    width = ds.RasterXSize
    height = ds.RasterYSize

    # Get coordinate transformation from file
    gt = ds.GetGeoTransform()

    # Transform pixel coordinates to UTM
    x0 = gt[0]
    y0 = gt[3] + width*gt[4] + height*gt[5]
    x1 = gt[0] + width*gt[1] + height*gt[2]
    y1 = gt[3]
    x = gt[0] + px*gt[1] + py*gt[2]
    y = gt[3] + px*gt[4] + py*gt[5]

    # Return as list
    return x, y

def get_pixel_coords(ds, type, px, py):
    # Cast shell args to ints
    px = int(px) * 1.0
    py = int(py) * 1.0

    # Return coords in desired CRS
    if type == "utm":
        return get_pixel_coords_utm(ds, px, py)
    elif type == "latlng":
        return get_pixel_coords_latlng(ds, px, py, "wgs84")


if __name__ == "__main__":
    cmd = sys.argv[1]
    file = sys.argv[2]
    args = sys.argv[3:]

    # Load file with gdal
    ds = gdal.Open(file)

    # Print results of requested op
    if cmd == "zone":
        print get_utm_zone(ds, *args)
    elif cmd == "pixel2coords":
        print get_pixel_coords(ds, *args)
    elif cmd == "proj4":
        print get_proj4(ds)
    elif cmd == "datum":
        print get_datum(ds, *args)