clearvars; close all; opengl hardware

addpath(genpath('src'))

%% 
NoL=14; % Number of Landmarks
NoS=20; % Number of Subjects
NoT=4; % Number of Trials

files=dir('..\ManualLandmarks\Pelvis\*.mat');
NoR=length(files); % Number of Rater
Rater=cell(NoR,1);
for r=1:NoR
    load(fullfile(files(r).folder, files(r).name),'Results')
    Rater{r}=Results;
    clearvars Results 
end
RaterNames=cellfun(@(x) strrep(x, '.mat', ''), {files.name},'uni',0);

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

% Load the subject list
load('res\VSD_Subjects.mat','Subjects')

% Visualize subjects in the CT coordinate system
cMapLM=lines(NoL);
cMapR=hsv(NoR);
markerR={'o','s','d','p','h'};
pelvis=repmat(struct('vertices',[],'faces',[]),20,1);
fakeHandles=nan(NoR,1);
for s=1:NoS
    % Load surface data
    load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
    % Construct pelvis and visualize
    [~, axH, figH] = visualizeMeshes(concatenateMeshes(B(1:3).mesh));
    set(figH,'NumberTitle','off', 'Name',['Subject: ' Subjects.Number{s}])
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