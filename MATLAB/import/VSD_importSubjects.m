%VSD_IMPORTSUBJECTS imports the surfaces of VSD subjects.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2019-2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all

addpath(genpath('..\src'))
VSD_addPathes('..\..\..\..\..\')

%% Settings
dicomDBpath = 'D:\sciebo\SMIR\VSDFullBodyBoneReconstruction';
subjectXLSX = '..\res\VSD_Subjects.xlsx';

visualizeSubjects = 1;

% Load subjects & meta data
Subjects = readtable(subjectXLSX);

%% Import
NoS = size(Subjects, 1);
patchProps.FaceAlpha = 0.5;
for s=1:NoS
    % Import data
    VSD_importData(Subjects(s,:), dicomDBpath)
    if visualizeSubjects
        load(['..\..\Bones\' Subjects.ID{s} '.mat'], 'B')
        visualizeMeshes([B(1:end).mesh],patchProps)
        anatomicalViewButtons('LPS')
        set(gcf,'Name',['VSD subject: ' Subjects.ID{s}],'NumberTitle','off')
%         axis off tight; view(0,0); 
%         title(Subjects.ID{s})
%         export_fig(Subjects.ID{s}, '-tif', '-r300')
%         close(gcf)
    end
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';