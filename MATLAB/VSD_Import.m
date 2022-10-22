clearvars; close all; opengl hardware

addpath(genpath('src'))
VSD_addPathes('..\..\..\..\')

%% Settings
dicomDBpath = 'D:\sciebo\SMIR\VSDFullBody';
subjectXLSX='res\VSD_Subjects.xlsx';

visualizeSubjects = 1;

% Load subjects & meta data
[~, ~, metaData] = xlsread(subjectXLSX);
Subjects=cell2table(metaData(2:end,:),'VariableNames',metaData(1,:));

%% Import
NoS = size(Subjects, 1);
patchProps.FaceAlpha = 0.5;
for s=1:NoS
    % Import data
    VSD_importData(Subjects(s,:), dicomDBpath)
    if visualizeSubjects
        load(['..\Bones\' Subjects.ID{s} '.mat'], 'B')
        visualizeMeshes([B(1:end).mesh],patchProps)
        anatomicalViewButtons('LPS')
        axis off tight; view(0,0); 
        set(gcf,'Name',['VSD subject: ' Subjects.ID{s}],'NumberTitle','off')
%         title(Subjects.ID{s})
%         export_fig(Subjects.ID{s}, '-tif', '-r300')
%         close(gcf)
    end
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';