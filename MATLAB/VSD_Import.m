clearvars; close all; opengl hardware

addpath(genpath('src'))
VSD_addPathes('..\..\..\..\')

%% Settings
dicomDBpath = 'G:\sciebo\SMIR\VSDFullBody';
subjectXLSX='res\VSD_Subjects.xlsx';

visualizeSubjects = 1;

% Load subjects & meta data
[~, ~, metaData] = xlsread(subjectXLSX);
header = metaData(1,:);
Subjects=cell2table(metaData(2:end,:),'VariableNames',metaData(1,:));
save('res\VSD_Subjects.mat', 'Subjects')

%% Import
NoS = size(Subjects, 1);
patchProps.FaceAlpha = 0.5;
for s=1:NoS
    % Import data
    VSD_importData(Subjects(s,:), dicomDBpath)
    if visualizeSubjects
        load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
        visualizeMeshes([B(1:5).mesh],patchProps)
        anatomicalViewButtons
        set(gcf,'Name',['Subject: ' Subjects.Number{s}])
    end
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';