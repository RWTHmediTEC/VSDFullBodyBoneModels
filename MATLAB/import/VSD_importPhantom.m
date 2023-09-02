%VSD_IMPORTPHANTOM imports the surface of the VSD phantom.
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
NoS = size(phantom, 1);
patchProps.FaceAlpha = 0.5;
for s=1:NoS
    % Import data
    VSD_importData(phantom(s,:), dicomDBpath, {'EuropeanSpinePhantom'})
    if visualizeSubjects
        load(['..\..\Bones\' phantom.ID{s} '.mat'], 'B')
        visualizeMeshes([B(1:end).mesh],patchProps)
        anatomicalViewButtons('ASR')
        set(gcf,'Name',['VSD: ' phantom.ID{s}],'NumberTitle','off')
    end
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';