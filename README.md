# VSDFullBodyBoneModels
Surface models of bones created from CT datasets of the open source VSDFullBody database hosted at www.smir.ch.
![z001](https://user-images.githubusercontent.com/43516130/75036561-727e1980-54b2-11ea-8e25-2e563c190ecb.PNG)

## Releases
- v1.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3384055.svg)](https://doi.org/10.5281/zenodo.3384055) contains only the bones of the pelvis of 20 subjects of the VSDFullBody database. 
Additionally, it contains manually selected pelvic landmarks of five experienced raters.
- v2.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4280899.svg)](https://doi.org/10.5281/zenodo.4280899) additionally contains the femora and manually selected femoral landmarks of five experienced raters.

## Usage 
The Bones directory contains a MATALB MAT file for each subject with the triangle meshes of the bones.

## Segmentation and reconstruction process
The surface of each bone was semi-automatically reconstructed by thresholding using 200 Hounsfield units as lower threshold and the maximum Hunsfield unit value present in the volume data as upper threshold.
The thresholding was followed by a manual post-processing procedure using the software 3D Slicer ([slicer.org](https://www.slicer.org)) with the default smoothing settings.
If necessary, the bones were manually segmented at the joint spaces. Subsequently, holes in the outer surface of the bones were manually closed.
The reconstructions were exported as mesh files in the Polygon File Format (PLY) and imported into MATLAB using a conservative decimation and remeshing procedure. 
The decimator restricted the Hausdorff distance between input and output mesh to 0.05 mm. 
The adaptive remesher permitted a maximum deviation of 0.05 mm from the input mesh with a minimum edge length of 0.5 mm and a maximal edge length of 100 mm. 
The decimator and remesher are plugins of the software OpenFlipper ([openflipper.org](https://www.openflipper.org)).

## License
[CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)