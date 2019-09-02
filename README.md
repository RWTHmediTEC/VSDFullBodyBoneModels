# VSDFullBodyBoneModels
Surface models of bones created from CT datasets of the open source VSDFullBody database hosted at www.smir.ch.

## Usage 
The Bones directory contains a MATALB MAT file for each subject with the triangle meshes of the bones.


## Segmentation and reconstruction process
The surface of each pelvis was semi-automatically reconstructed by thresholding followed by a manual post-processing using the software 3D Slicer (www.slicer.org) with the default smoothing settings. 
If necessary, the pelvic bones were manually segmented at the pubic symphysis and the sacroiliac joints. 
The reconstructed surfaces were imported into MATLAB using a conservative decimation and remeshing procedure. 
The decimator restricted the Hausdorff distance between input and output mesh to 0.05 mm. 
The adaptive remesher permitted a maximum deviation of 0.05 mm from the input mesh with a minimum edge length of 0.5 mm and a maximal edge length of 100 mm. 
The decimator and remesher are plugins of the software OpenFlipper (www.openflipper.org).
The original segmentations and reconstructions can be found as MHA files in the VSDFullBody database hosted at www.smir.ch.

## Versions
v1.0 contains only the bones of the pelvis of 20 subjects of the VSDFullBody database. 
Additionally, it contains manual selected pelvic landmarks of five experienced raters.

## License
CC BY-NC-SA