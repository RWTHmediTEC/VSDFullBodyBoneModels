% VISUALIZEMANUALLANDMARKS visualizes the manually selected landmarks.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2019-2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all; opengl hardware

addpath(genpath('src'))

% Select the bone
bone = 'Femur'; % 'Pelvis' or 'Femur'

% Select subjects of the VSD
files=dir(['..\ManualLandmarks\' bone '\*.mat']);
load(fullfile(files(1).folder, files(1).name),'Results')
switch bone
    case 'Pelvis'
        Subjects = Results(:,5);
    case 'Femur'
        Subjects = Results(:,5:6);
end

% Number of Rater
NoR=length(files);
Rater=cell(NoR,1);
for r=1:NoR
    load(fullfile(files(r).folder, files(r).name),'Results')
    Rater{r} = Results;
    clearvars Results 
end
RaterNames=cellfun(@(x) strrep(x, '.mat', ''), {files.name},'uni',0);

% Number of Subjects
NoS = size(Rater{1,1},1);
% Number of Trials
NoT = sum(all(~cellfun(@ischar, Rater{1,1}),1));
% Number of Landmarks
NoL = size(Rater{1,1}{1,1},1);

% Reshape results of the raters to manuLM cell
manuLM_CT_Cell=cell(NoL,NoS,NoR,NoT);
for l=1:NoL
    for s=1:NoS
        for r=1:NoR
            for t=1:NoT
                manuLM_CT_Cell{l,s,r,t}=Rater{r}{s,t}{l,2};
            end
        end
    end
end

% Visualize subjects in the CT coordinate system
cMapLM=lines(NoL);
markerR={'o','s','d','p','h'};
for s=1:NoS
    name = Subjects{s,1};
    % Load surface data
    load(['..\Bones\' name '.mat'], 'B')
    switch bone
        case 'Pelvis'
            mesh = concatenateMeshes(B(1:3).mesh);
        case 'Femur'
            side = Subjects{s,2};
            mesh = B(ismember({B.name}, ['Femur_' side])).mesh;
    end
    % Construct pelvis and visualize
    [~, axH, figH] = visualizeMeshes(mesh);
    set(figH,'NumberTitle','off', 'Name',['Subject: ' name])
    anatomicalViewButtons(axH,'LPS')
    for r=1:NoR
        for t=1:NoT
            for l=1:NoL
                % Draw manual identified landmarks with a different marker
                % style for each rater
                drawPoint3d(axH, manuLM_CT_Cell{l,s,r,t}, 'Marker', markerR{r},...
                    'MarkerFaceColor', cMapLM(l,:), 'MarkerEdgeColor', 'k');
            end
        end
    end
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';