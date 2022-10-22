function [optiMesh, optiInfo] = VSD_optimizeMeshWrapper(mesh)
%VSD_OPTIMIZEMESHWRAPPER optimizes the 3D surface models of the VSD
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2022 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

% Settings of OptimizeMesh
Set.Visualization = 0;
Set.Verbose = 0;
Set.MeshStatistics = 0;

% BIGGEST COMPONENT
Set.BiggestComponent = 'MaxBoundingBox'; % 'MaxBoundingBox', 'MaxVolume'

% ORIENT OUTWARDS
Set.OrientOutwards = 0;

% MESHFIX
Set.MeshFix.Path = 'C:\Program Files\MeshFix-V2.1\bin64\meshfix.exe';

% OPENFLIPPER
Set.OpenFlipper.Path = 'C:\Program Files\OpenFlipper 3.1\OpenFlipper.exe';
% Decimater
Set.OpenFlipper.Decimater.distance = 0.05; % Max. Hausdorff dist. between in- & output mesh
% Set.OpenFlipper.Decimater.normal_deviation = 5; % Max. deviation of the normal in degree
% Uniform Remesher
% Average edge length. For increasing values the shrinkage of the mesh increases, too.
% Set.OpenFlipper.Remesher.Uniform.EdgeLength = 1;
% Set.OpenFlipper.Remesher.Uniform.Iterations = 5;
% Set.OpenFlipper.Remesher.Uniform.AreaIterations = 10;
% Set.OpenFlipper.Remesher.Uniform.Projection = 'false';
% Adaptive Remesher
Set.OpenFlipper.Remesher.Adaptive.Error = 0.05; % Max. deviation from the input mesh
Set.OpenFlipper.Remesher.Adaptive.MinEdgeLength = 0.5; % Min. edge length
Set.OpenFlipper.Remesher.Adaptive.MaxEdgeLength = 100; % Max. edge length
Set.OpenFlipper.Remesher.Adaptive.Iterations = 5; % No. of iterations
Set.OpenFlipper.Remesher.Adaptive.Projection = 'false';

% MESHLAB
% Set.MeshLab.Path = 'C:\Program Files\VCG\MeshLab\meshlabserver.exe';
% % TaubinSmooth
% Set.MeshLab.TaubinSmooth.lambda = 0.7;
% Set.MeshLab.TaubinSmooth.mu = -0.67;
% Set.MeshLab.TaubinSmooth.stepSmoothNum = 200;

[optiMesh, optiInfo] = optimizeMesh(mesh, Set);

end