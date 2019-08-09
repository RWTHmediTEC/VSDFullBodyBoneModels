clearvars; close all; opengl hardware

addpath('src')
VSD_addPathes('..\..\..\..\')

%% Settings
dicomDBpath = 'G:\sciebo\SMIR\VSDFullBody';
subjectFile='res\VSD_Subjects.xlsx';

visualizeSubjects=1;

% Load subjects & meta data
if ~exist('res\VSD_Subjects.mat', 'file')
    [~, ~, metaData] = xlsread(subjectFile);
    header = metaData(1,:);
    Subjects=cell2table(metaData(2:end,:),'VariableNames',metaData(1,:));
    save('res\VSD_Subjects.mat', 'Subjects')
else
    load('res\VSD_Subjects.mat', 'Subjects')
end

%% Import
NoS=size(Subjects, 1);
for s=1%:NoS
    % Import data
    VSD_importData(Subjects.Number{s}, Subjects.Age(s), Subjects.Sex{s}, dicomDBpath)
    if visualizeSubjects
        load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
        visualizeMeshes([B(1:5).mesh])
        medicalViewButtons('RAS')
    end
end

