% VISUALIZEMANUALLANDMARKS visualizes the manually selected landmarks
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2020 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all; opengl hardware

addpath(genpath('src'))

% Select the bone
bone = 'Femur'; % 'Pelvis' or 'Femur'

% Select subjects of the VSD
Subjects = [1 9 13 19 23 24 27 35 36 42 46 49 50 55 56 57 61 62 64 66];
Subjects = arrayfun(@(x) ['z' num2str(x, '%03i')], Subjects', 'uni',0);
Subjects(1:2:20,2) = {'L'}; Subjects(2:2:20,2) = {'R'};

files=dir(['..\ManualLandmarks\' bone '\*.mat']);
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
            assert(strcmp(Subjects{s,1},Rater{r}{s,5}));
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
    side = Subjects{s,2};
    % Load surface data
    load(['..\Bones\' name '.mat'], 'B')
    switch bone
        case 'Pelvis'
            mesh = concatenateMeshes(B(1:3).mesh);
        case 'Femur'
            mesh = B(ismember({B.name}, ['Femur_' side])).mesh;
    end
    % Construct pelvis and visualize
    [~, axH, figH] = visualizeMeshes(mesh);
    set(figH,'NumberTitle','off', 'Name',['Subject: ' name])
    anatomicalViewButtons(axH)
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