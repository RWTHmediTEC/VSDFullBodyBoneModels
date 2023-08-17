function VSD_addPathes(prefix)
%VSD_ADDPATHES adds the pathes required for the VSD scripts.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2022-2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

%% For VSD_import*
% https://github.com/MCM-Fischer/OptimizeMesh
addpath(genpath([prefix 'General\Code\optimizeMesh']))

% https://github.com/altmany/export_fig
addpath(genpath([prefix 'General\Code\#external\#Visualization\export_fig']))

%% For analyzePhantom.m
% https://github.com/mattools/matGeom
addpath(genpath([prefix 'General\Code\#external\matGeom']))

% https://github.com/MCM-Fischer/ManualFaceSelection
addpath(genpath([prefix 'General\Code\ManualFaceSelection']))

% https://github.com/MCM-Fischer/ManualLandmarkSelection
addpath(genpath([prefix 'General\Code\ManualLandmarkSelection']))

% https://www.mathworks.com/matlabcentral/fileexchange/87584-object-oriented-tools-for-fitting-conics-and-quadrics
addpath(genpath([prefix 'General\Code\#external\#Fitting\conic-fit-tools']))

end