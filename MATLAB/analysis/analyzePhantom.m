%ANALYZEPHANTOM analyzes the surface model of the VSD phantom.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all

addpath(genpath('..\src'))
VSD_addPathes('..\..\..\..\..\')

%% Settings
dicomDBpath = 'D:\sciebo\SMIR\VSDFullBodyBoneReconstruction';
phantomXLSX = '..\res\VSD_Phantom.xlsx';

visualizeSubjects = 1;

% Load phantom
phantom = readtable(phantomXLSX);

%% Import
patchProps.FaceAlpha = 0.3;
load(['..\..\Bones\' phantom.ID{1} '.mat'], 'B')
phantomMesh = B(1).mesh;
visualizeMeshes(phantomMesh,patchProps)
anatomicalViewButtons('ASR')
set(gcf,'Name',['VSD phantom: ' phantom.ID{1}],'NumberTitle','off')

phantomAreaFile = '..\res\VSD_PhantomAnnotations.mat';

if exist(phantomAreaFile, 'file')
    load(phantomAreaFile,'areas','points')
else
    areas = {...
        'LV_Body'; 'LV_SuperiorEndPlate'; 'LV_InferiorEndPlate'; 'LV_RightSpinProcess'; 'LV_LeftSpinProcess';...
        'MV_Body'; 'MV_SuperiorEndPlate'; 'MV_InferiorEndPlate'; 'MV_RightSpinProcess'; 'MV_LeftSpinProcess';...
        'HV_Body'; 'HV_SuperiorEndPlate'; 'HV_InferiorEndPlate'; 'HV_RightSpinProcess'; 'HV_LeftSpinProcess';...
        'PostArch'; 'LV_AntArch'; 'MV_AntArch'; 'HV_AntArch';...
        'LV_SpinProcessBase'; 'MV_SpinProcessBase'; 'HV_SpinProcessBase'};
    points = {'LV_SpinProcess'; 'MV_SpinProcess'; 'HV_SpinProcess'};
end

%% Define areas
% areas = selectFaces(phantomMesh, areas);
% save(phantomAreaFile,'areas','points')
% 
% % Define points
% points = selectLandmarks(phantomMesh, points);
% save(phantomAreaFile,'areas','points')

%% Analyze areas
pointProps.Marker = 'o';
pointProps.MarkerSize = 8;
pointProps.MarkerEdgeColor = 'k';
pointProps.MarkerFaceColor = 'k';

resTable{1,1} = 'Body diameter';
resTable{2,1} = 'Arch diameter';
resTable{3,1} = 'Body height';
resTable{4,1} = 'Arch thickness';
resTable{5,1} = 'Spinous process thickness';
resTable{6,1} = 'Spinous process length';

resTableRef = resTable;
resTableRef{1,2} = 36; resTableRef{1,3} = 36; resTableRef{1,4} = 36;
resTableRef{2,2} = 28; resTableRef{2,3} = 28; resTableRef{2,4} = 28;
resTableRef{3,2} = 25; resTableRef{3,3} = 25; resTableRef{3,4} = 25;
resTableRef{4,2} = 5.2; resTableRef{4,3} = 6.0; resTableRef{4,4} = 7.0;
resTableRef{5,2} = 6.0; resTableRef{5,3} = 8.0; resTableRef{5,4} = 10.0;
resTableRef{6,2} = 11.7; resTableRef{6,3} = 14.6; resTableRef{6,4} = 21.0;

[PostArchVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'PostArch'),2});
PostArchCyl=cylindricalFit(PostArchVerts');
ArchDia = PostArchCyl.radius*2;
drawCylinder(cylindricalFitToCylinder(PostArchCyl), 128, 'FaceColor','g', 'FaceAlpha',0.5)

resTable{2,2} = ArchDia; resTable{2,3} = ArchDia; resTable{2,4} = ArchDia;

disp('--- Low Vertebra ---')
% Body diameter
[LV_BodyVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_Body'),2});
LV_BodyCyl = cylindricalFit(LV_BodyVerts');
drawCylinder(cylindricalFitToCylinder(LV_BodyCyl), 128, 'FaceColor','r', 'FaceAlpha',0.5)
resTable{1,2} = LV_BodyCyl.radius*2;

% Body height
[LV_SuperiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_SuperiorEndPlate'),2});
LV_SuperiorEndPlane = fitPlane(LV_SuperiorEndPlateVertices);
[LV_InferiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_InferiorEndPlate'),2});
LV_InferiorEndPlane = fitPlane(LV_InferiorEndPlateVertices);
drawPlatform(LV_SuperiorEndPlane, 36);
drawPlatform(LV_InferiorEndPlane, 36);
resTable{3,2} = abs(LV_InferiorEndPlane(2)-LV_SuperiorEndPlane(2));

% Arch thickness
[LV_AntArchVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_AntArch'),2});
LV_AntArchCyl = cylindricalFit(LV_AntArchVerts');
drawCylinder(cylindricalFitToCylinder(LV_AntArchCyl), 128, 'FaceColor','b', 'FaceAlpha',1)
resTable{4,2} = PostArchCyl.radius-LV_AntArchCyl.radius;

% Spinous process thickness
[LV_RightSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_RightSpinProcess'),2});
LV_RightSpinPlane = fitPlane(LV_RightSpinProcess);
[LV_LeftSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_LeftSpinProcess'),2});
LV_LeftSpinPlane = fitPlane(LV_LeftSpinProcess);
resTable{5,2} = abs(LV_LeftSpinPlane(3)-LV_RightSpinPlane(3));

% Spinous process length
[LV_SpinProcessBaseVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'LV_SpinProcessBase'),2});
LV_SpinProcessBase = fitPlane(LV_SpinProcessBaseVerts);
LV_SpinProcess = points{strcmp(points(:,1),'LV_SpinProcess'),2};
LV_SpinProcessProj = projPointOnPlane(LV_SpinProcess, LV_SpinProcessBase);
drawEdge([LV_SpinProcess, LV_SpinProcessProj], 'Color', 'k', pointProps, 'LineWidth',2)
drawPlatform(LV_SpinProcessBase, 10);
resTable{6,2} = distancePoints3d(LV_SpinProcess, LV_SpinProcessProj);

disp('--- Medium Vertebra ---')
% Body diameter
[MV_BodyVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_Body'),2});
MV_BodyCyl = cylindricalFit(MV_BodyVerts');
drawCylinder(cylindricalFitToCylinder(MV_BodyCyl), 128, 'FaceColor','r', 'FaceAlpha',0.5)
resTable{1,3} = MV_BodyCyl.radius*2;

% Body height
[MV_SuperiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_SuperiorEndPlate'),2});
MV_SuperiorEndPlane = fitPlane(MV_SuperiorEndPlateVertices);
[MV_InferiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_InferiorEndPlate'),2});
MV_InferiorEndPlane = fitPlane(MV_InferiorEndPlateVertices);
drawPlatform(MV_SuperiorEndPlane, 36);
drawPlatform(MV_InferiorEndPlane, 36);
resTable{3,3} = abs(MV_InferiorEndPlane(2)-MV_SuperiorEndPlane(2));

% Arch thickness
[MV_AntArchVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_AntArch'),2});
MV_AntArchCyl = cylindricalFit(MV_AntArchVerts');
drawCylinder(cylindricalFitToCylinder(MV_AntArchCyl), 128, 'FaceColor','b', 'FaceAlpha',1)
resTable{4,3} = PostArchCyl.radius-MV_AntArchCyl.radius;

% Spinous process thickness
[MV_RightSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_RightSpinProcess'),2});
MV_RightSpinPlane = fitPlane(MV_RightSpinProcess);
[MV_LeftSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_LeftSpinProcess'),2});
MV_LeftSpinPlane = fitPlane(MV_LeftSpinProcess);
resTable{5,3} = abs(MV_LeftSpinPlane(3)-MV_RightSpinPlane(3));

% Spinous process length
MV_SpinProcess = points{strcmp(points(:,1),'MV_SpinProcess'),2};
[MV_SpinProcessBaseVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'MV_SpinProcessBase'),2});
MV_SpinProcessBase = fitPlane(MV_SpinProcessBaseVerts);
MV_SpinProcessProj = projPointOnPlane(MV_SpinProcess, MV_SpinProcessBase);
drawEdge([MV_SpinProcess, MV_SpinProcessProj], 'Color', 'k', pointProps, 'LineWidth',2)
drawPlatform(MV_SpinProcessBase, 10);
resTable{6,3} = distancePoints3d(MV_SpinProcess, MV_SpinProcessProj);

disp('--- High Vertebra ---')
% Body diameter
[HV_BodyVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_Body'),2});
HV_BodyCyl = cylindricalFit(HV_BodyVerts');
drawCylinder(cylindricalFitToCylinder(HV_BodyCyl), 128, 'FaceColor','r', 'FaceAlpha',0.5)
resTable{1,4} = HV_BodyCyl.radius*2;

% Body height
[HV_SuperiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_SuperiorEndPlate'),2});
HV_SuperiorEndPlane = fitPlane(HV_SuperiorEndPlateVertices);
[HV_InferiorEndPlateVertices, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_InferiorEndPlate'),2});
HV_InferiorEndPlane = fitPlane(HV_InferiorEndPlateVertices);
drawPlatform(HV_SuperiorEndPlane, 36);
drawPlatform(HV_InferiorEndPlane, 36);
resTable{3,4} = abs(HV_InferiorEndPlane(2)-HV_SuperiorEndPlane(2));

% Arch thickness
[HV_AntArchVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_AntArch'),2});
HV_AntArchCyl=cylindricalFit(HV_AntArchVerts');
drawCylinder(cylindricalFitToCylinder(HV_AntArchCyl), 128, 'FaceColor','b', 'FaceAlpha',1)
resTable{4,4} = PostArchCyl.radius-HV_AntArchCyl.radius;

% Spinous process thickness
[HV_RightSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_RightSpinProcess'),2});
HV_RightSpinPlane = fitPlane(HV_RightSpinProcess);
[HV_LeftSpinProcess, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_LeftSpinProcess'),2});
HV_LeftSpinPlane = fitPlane(HV_LeftSpinProcess);
resTable{5,4} = abs(HV_LeftSpinPlane(3)-HV_RightSpinPlane(3));

% Spinous process length
HV_SpinProcess = points{strcmp(points(:,1),'HV_SpinProcess'),2};
[HV_SpinProcessBaseVerts, ~] = removeMeshFaces(phantomMesh, ~areas{strcmp(areas(:,1),'HV_SpinProcessBase'),2});
HV_SpinProcessBase = fitPlane(HV_SpinProcessBaseVerts);
HV_SpinProcessProj = projPointOnPlane(HV_SpinProcess, HV_SpinProcessBase);
drawEdge([HV_SpinProcess, HV_SpinProcessProj], 'Color', 'k', pointProps, 'LineWidth',2)
drawPlatform(HV_SpinProcessBase, 10);
resTable{6,4} = distancePoints3d(HV_SpinProcess, HV_SpinProcessProj);

grid off; axis off

% Error
errorsCell = cellfun(@(x,y) x-y, resTable(:,2:4), resTableRef(:,2:4), 'UniformOutput', false);
errors = cell2mat(errorsCell);
errors = unique(errors(:));
disp(['Mean error: ' num2str(mean(errors), 1) ' ' char(177) ' ' num2str(std(errors), 1)])
disp(['Mean absolute error: ' num2str(mean(abs(errors)), 1) ' ' char(177) ' ' num2str(std(abs(errors)), 1)])

writecell([resTable, resTableRef(:,2:4), errorsCell], 'phantomResults.xlsx', 'Sheet','Phantom', 'Range','B5')

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';

%% Helper functions
function [cylinder, cylLine] = cylindricalFitToCylinder(cylFit)

cylTfm = eulerAnglesToRotation3d(cylFit.yaw, cylFit.pitch, cylFit.roll);
cylVector = transformVector3d([1 0 0], cylTfm);
cylLine = [cylFit.center cylVector];
cylPoints = transformPoint3d(cylFit.XYZ', cylTfm');
[~, minIdx] = min(cylPoints(:,1));
[~, maxIdx] = max(cylPoints(:,1)); 
minPtProj = projPointOnLine3d(cylFit.XYZ(:,minIdx)', cylLine);
maxPtProj = projPointOnLine3d(cylFit.XYZ(:,maxIdx)', cylLine);
cylinder = [minPtProj, maxPtProj, cylFit.radius];

end