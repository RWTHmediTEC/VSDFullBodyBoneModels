# VSDFullBodyBoneModels
3D surface models of the bones of the lower body created from CT datasets of the open access VSDFullBody collection.
![subject-selection](https://github.com/MCM-Fischer/VSDFullBodyBoneModels/assets/43516130/b1e706f4-8b43-42d6-b249-1633aaa28381)

## How to cite
### Publication
Fischer, M. C. M. Database of segmentations and surface models of bones of the entire lower body created from cadaver CT scans. *Sci. Data* **10**, 763; [10.1038/s41597-023-02669-z](https://doi.org/10.1038/s41597-023-02669-z) (2023).

### Releases
- v3.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8316730.svg)](https://doi.org/10.5281/zenodo.8316730) The database contains the bones of the lower extremities of 30 subjects. One duplicate subject (z024) was removed from the database that was part of the previous versions.
- v2.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4280899.svg)](https://doi.org/10.5281/zenodo.4280899) additionally contains the femora and manually selected femoral landmarks of five experienced raters.
- v1.0 [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3384055.svg)](https://doi.org/10.5281/zenodo.3384055) contains only the bones of the pelvis of 20 subjects of the VSDFullBody database. Additionally, it contains manually selected pelvic landmarks of five experienced raters.

## Usage
In the Bones folder a MATALB MAT file is stored for each subject containing the triangle meshes of the bones.
Clone with the recursive option to get the submodules.
Run the MATLAB or Python example script to plot one of the subjects: `plotBoneModels_example.m` or `plotBoneModels_example.py`.

## Segmentation and reconstruction process
The surface of each bone was semi-automatically reconstructed by thresholding using 200 Hounsfield units as the lower threshold and the maximum Hunsfield unit value present in the volume data as the upper threshold.
The thresholding was followed by a manual post-processing procedure using the software 3D Slicer ([slicer.org](https://www.slicer.org)) with default smoothing settings.
The bones were manually segmented at the joint spaces if necessary. Subsequently, holes in the outer surface of the bones were manually closed.
The reconstructions were exported as mesh files in the PLY format (see '**[Related data](https://github.com/MCM-Fischer/VSDFullBodyBoneModels#related-data)**') and imported into MATLAB using a conservative decimation and remeshing procedure. 
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
- v2.0 was used in: Fischer, M. C. M. *et al.* A robust method for automatic identification of femoral landmarks, axes, planes and bone coordinate systems using surface models. *Sci. Rep.* **10**, 20859; [10.1038/s41598-020-77479-z](https://doi.org/10.1038/s41598-020-77479-z) (2020).
- v1.0 was used in: Fischer, M. C. M. *et al.* A robust method for automatic identification of landmarks on surface models of the pelvis. *Sci. Rep.* **9**, 13322; [10.1038/s41598-019-49573-4](https://doi.org/10.1038/s41598-019-49573-4) (2019).