__author__ = 'briana'


import sys
import os
import math

import skimage.io
import skimage.exposure
import numpy as np


SOLAR_IRRADIANCE = {
    'LT4': {5: 214.700, 4: 1033.000, 3: 1554.000},
    'LT5': {5: 214.900, 4: 1036.000, 3: 1551.000},
    'LE7': {5: 225.700, 4: 1044.000, 3: 1547.000}
}


def get_value_from_file(filename, content):
    for line in open(filename, 'r'):
        if content in line:
            return float(line.split('=')[1].strip())


def process_scene(sceneID, sun_elevation, d):
    sun_elevation = float(sun_elevation)
    d = float(d)
    bands = {5: [], 4: [], 3: []}
    metadata = os.path.join('temp', sceneID, "{sceneID}_MTL.txt".format(sceneID=sceneID))
    for band in bands:
        filename = os.path.join('temp', sceneID, "{sceneID}_B{band}.TIF".format(sceneID=sceneID, band=band))
        im = skimage.io.imread(filename)

        #
        #im = transform.resize(im, (500, 500))

        solar_irradiance = SOLAR_IRRADIANCE[sceneID[0:3]][band]
        gain = get_value_from_file(metadata, "RADIANCE_MULT_BAND_{}".format(band))
        bias = get_value_from_file(metadata, "RADIANCE_ADD_BAND_{}".format(band))
        sun_zenith_angle = math.cos(math.radians(90 - sun_elevation))

        #convert calibrated numbers back to radiance,
        radiance = im * gain + bias
        reflectance = math.pi * d * radiance / (solar_irradiance * sun_zenith_angle)

        #make sure all values are positive
        if np.min(reflectance.flat) < 0:
            reflectance = reflectance - np.min(reflectance.flat)

        gamma = 1.2
        final = 255 * reflectance**(1/gamma)
        bands[band] = final

    #merge and scale bands to 0-255 together to maintain color balance

    img = np.zeros((im.shape[0], im.shape[1], 3), dtype=np.float)
    img[:, :, 0] = bands[5]
    img[:, :, 1] = bands[4]
    img[:, :, 2] = bands[3]

    img = skimage.exposure.rescale_intensity(img)

    skimage.io.imsave(os.path.join('temp', sceneID, "{sceneID}_B5_calibrated.TIF".format(sceneID=sceneID)), img[:, :, 0])
    skimage.io.imsave(os.path.join('temp', sceneID, "{sceneID}_B4_calibrated.TIF".format(sceneID=sceneID)), img[:, :, 1])
    skimage.io.imsave(os.path.join('temp', sceneID, "{sceneID}_B3_calibrated.TIF".format(sceneID=sceneID)), img[:, :, 2])


if __name__ == "__main__":
    process_scene(*sys.argv[1:])
    #process_scene(*['LE70400372000195EDC00', '64.97591318', '1.0165049'])