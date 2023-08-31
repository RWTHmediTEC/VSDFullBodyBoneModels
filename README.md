
# VSDFullBodyBoneModels
Surface models of bones of the the lower extremities created from CT datasets of the open access VSDFullBody.
![z001](https://github.com/MCM-Fischer/VSDFullBodyBoneModels/assets/43516130/86cf5874-99dd-4b57-8b99-dba3c567f089)

## Releases
- v3.0 The database contains the bones of the lower extremities of 30 subjects. One duplicate subject (z024) was removed from the database that was part of previous versions.
- v2.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4280899.svg)](https://doi.org/10.5281/zenodo.4280899) additionally contains the femora and manually selected femoral landmarks of five experienced raters.
- v1.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3384055.svg)](https://doi.org/10.5281/zenodo.3384055) contains only the bones of the pelvis of 20 subjects of the VSDFullBody database. 
Additionally, it contains manually selected pelvic landmarks of five experienced raters.

## Usage
In the Bones folder a MATALB MAT file is stored for each subject containing the triangle meshes of the bones.

Run the MATLAB or Python example script to plot one of the subjects: `plotBoneModels_example.m` or `plotBoneModels_example.py`.

## Segmentation and reconstruction process
The surface of each bone was semi-automatically reconstructed by thresholding using 200 Hounsfield units as the lower threshold and the maximum Hunsfield unit value present in the volume data as the upper threshold.
The thresholding was followed by a manual post-processing procedure using the software 3D Slicer ([slicer.org](https://www.slicer.org)) with default smoothing settings.
The bones were manually segmented at the joint spaces if necessary. Subsequently, holes in the outer surface of the bones were manually closed.
The reconstructions were exported as mesh files in the Polygon File Format (PLY) and imported into MATLAB using a conservative decimation and remeshing procedure. 
The decimator restricted the Hausdorff distance between input and output mesh to 0.05 mm. 
The adaptive remesher permitted a maximum deviation of 0.05 mm from the input mesh with a minimum edge length of 0.5 mm and a maximal edge length of 100 mm. 
The decimator and remesher are plugins of the software OpenFlipper ([openflipper.org](https://www.openflipper.org)).

## Related data
- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8302448.svg)](https://doi.org/10.5281/zenodo.8302448) CT volume data, segmentations, reconstructions and raw PLY mesh files of each subject linked by a project file (MRML scene file) that can be opened with 3D Slicer ([slicer.org](https://www.slicer.org)).
- [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8270364.svg)](https://doi.org/10.5281/zenodo.8270364) Mirror of the full VSDFullBody database as hosted originally by Michael Kistler at [smir.ch](https://www.smir.ch).

## Licenses
- [![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/) for MAT and XLSX files.
- [![License: EUPL v1.2](https://img.shields.io/badge/License-EUPL_v1.2-lightgrey.svg)](https://eupl.eu/1.2/en/) for MATLAB and Python source code.

## Related publications
- v3.0 was published in: 
- v2.0 was used in: Fischer, M. C. M. et al. A robust method for automatic identification of femoral landmarks, axes, planes and bone coordinate systems using surface models. Sci. Rep. 10, 20859; [10.1038/s41598-020-77479-z](https://doi.org/10.1038/s41598-020-77479-z) (2020).
- v1.0 was used in: Fischer, M. C. M. et al. A robust method for automatic identification of landmarks on surface models of the pelvis. Sci. Rep. 9, 13322; [10.1038/s41598-019-49573-4](https://doi.org/10.1038/s41598-019-49573-4) (2019).