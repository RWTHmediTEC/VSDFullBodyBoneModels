clearvars; close all; opengl hardware

addpath(genpath('src'))
VSD_addPathes('..\..\..\..\')

% Load subjects & meta data
subjectXLSX = 'res\VSD_Subjects.xlsx';
Subjects = readtable(subjectXLSX);
NoS = size(Subjects, 1);

load(['..\Bones\' Subjects.ID{1} '.mat'], 'B')
NoB = length(B);
boneNames = {B.name};
clear B

%% Mesh sanity checks
NoCC = nan(NoS, NoB);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.ID{s} '.mat'], 'B')
    for b=1:length(B)
        stats = statistics(B(b).mesh.vertices, B(b).mesh.faces);
        sanityStats = rmfield(stats, {'num_faces', 'num_vertices', 'num_edges', ...
            'num_connected_components', 'num_handles', 'euler_characteristic'});
        if ~all(full(cell2mat(struct2cell(sanityStats)))==0)
            error([Subjects.ID{s} ' (' num2str(s) '): ' B(b).name ' (' num2str(b) ')'])
        end
        NoCC(s,b) = stats.num_connected_components;
    end
end

save('NumberOfConnComp.mat','NoCC')

% Check for intersections of adjacent bones
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.ID{s} '.mat'], 'B')
    mesh = concatenateMeshes([B(1:end).mesh]);
    stats = statistics(mesh.vertices, mesh.faces);
    if stats.num_selfintersecting_pairs ~= 0
        error([Subjects.ID{s} ' has intersections between adjacent bones!'])
    end
end

%% Mesh volume
% Remove incomplete or inconsistent subjects
Subjects = Subjects(cellfun(@(x) isempty(strfind(lower(x),'cut off')), Subjects.Comment),:); %#ok<STREMP>
Subjects = Subjects(cellfun(@(x) isempty(strfind(lower(x),'total knee')), Subjects.Comment),:); %#ok<STREMP>
Subjects = Subjects(cellfun(@(x) isempty(strfind(lower(x),'incorrectly')), Subjects.Comment),:); %#ok<STREMP>
Subjects = Subjects(cellfun(@(x) isempty(strfind(lower(x),'conflicting')), Subjects.Comment),:); %#ok<STREMP>
Subjects = Subjects(~isnan(Subjects.Weight),:);
% Calculate volume of the bone models
NoS = size(Subjects, 1);
volume = nan(NoS, NoB);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.ID{s} '.mat'], 'B')
    for b=1:length(B)
        volume(s,b) = VolumeIntegrate(B(b).mesh.vertices,B(b).mesh.faces);
        % volume(s,b) = sum(arrayfun(@(x) meshVolume(x), splitMesh(B(b).mesh)));
    end
end

cmm3toccm3 = 0.001;
volumeTable = cell2table(cell(NoB,13), 'VariableNames', {...
    'Bone name', 'Min.', 'Mean', 'Median', 'Max.',...
    'M_Min.', 'M_Mean', 'M_Median', 'M_Max.',...
    'F_Min.', 'F_Mean', 'F_Median', 'F_Max.'});
[minIdx, maxIdx] = deal(nan(NoS, 1));
mIdx = strcmp(Subjects.Sex, 'M');
assert(sum(mIdx) == 10)
fIdx = strcmp(Subjects.Sex, 'F');
assert(sum(fIdx) == 10)
assert(sum(fIdx & mIdx) == 0)
for b=1:NoB
    % All
    volumeTable(b,1) = boneNames(b);
    [minValue, minIdx(b)] = min(volume(:,b)*cmm3toccm3);
    volumeTable{b,2} = {minValue};
    volumeTable(b,3) = meanStats(volume(:,b)*cmm3toccm3,'% 1.0f','format','short');
    volumeTable(b,4) = medianStats(volume(:,b)*cmm3toccm3,'% 1.0f','format','short');
    [maxValue, maxIdx(b)] = max(volume(:,b)*cmm3toccm3);
    volumeTable{b,5} = {maxValue};
    % Male
    [minValue, minIdx(b)] = min(volume(mIdx,b)*cmm3toccm3);
    volumeTable{b,6} = {minValue};
    volumeTable(b,7) = meanStats(volume(mIdx,b)*cmm3toccm3,'% 1.0f','format','short');
    volumeTable(b,8) = medianStats(volume(mIdx,b)*cmm3toccm3,'% 1.0f','format','short');
    [maxValue, maxIdx(b)] = max(volume(mIdx,b)*cmm3toccm3);
    volumeTable{b,9} = {maxValue};
    % Female
    [minValue, minIdx(b)] = min(volume(fIdx,b)*cmm3toccm3);
    volumeTable{b,10} = {minValue};
    volumeTable(b,11) = meanStats(volume(fIdx,b)*cmm3toccm3,'% 1.0f','format','short');
    volumeTable(b,12) = medianStats(volume(fIdx,b)*cmm3toccm3,'% 1.0f','format','short');
    [maxValue, maxIdx(b)] = max(volume(fIdx,b)*cmm3toccm3);
    volumeTable{b,13} = {maxValue};
end

writetable(volumeTable, 'volumeResults.xlsx', 'Sheet','Volume', 'Range','B5',...
    'WriteVariableNames',0, 'WriteRowNames',0)

% figure('color','w')
% bph = boxplot(volume,boneNames,'LabelOrientation','inline');
% set(findobj(get(bph(1), 'parent'), 'type', 'text'), 'interpreter','tex');

%% Age, weight, height
SubjectStats(1,1) = meanStats(Subjects.Age,'% 1.0f','format','short');
SubjectStats(1,2) = meanStats(Subjects.Weight,'% 1.0f','format','short');
SubjectStats(1,3) = meanStats(Subjects.Height,'% 1.1f','format','short');
SubjectStats(2,1) = medianStats(Subjects.Age,'% 1.0f','format','short');
SubjectStats(2,2) = medianStats(Subjects.Weight,'% 1.0f','format','short');
SubjectStats(2,3) = medianStats(Subjects.Height,'% 1.1f','format','short');

%% Number of vertices
NoV = nan(NoS, NoB);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.ID{s} '.mat'], 'B')
    for b=1:length(B)
        NoV(s,b) = size(B(b).mesh.vertices,1);
    end
end

figure('color','w','numbertitle','off','name','Number of mesh vertices')
bph = boxplot(NoV,boneNames,'LabelOrientation','inline');
set(findobj(get(bph(1), 'parent'), 'type', 'text'), 'interpreter','tex');

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';