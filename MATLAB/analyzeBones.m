clearvars; close all; opengl hardware

addpath(genpath('src'))
VSD_addPathes('..\..\..\..\')

% Load subjects & meta data
subjectXLSX = 'res\VSD_Subjects.xlsx';
[~, ~, metaData] = xlsread(subjectXLSX);
Subjects = cell2table(metaData(2:end,:),'VariableNames',metaData(1,:));
NoS = size(Subjects, 1);

load(['..\Bones\' Subjects.Number{1} '.mat'], 'B')
NoB = length(B);
boneNames = {B.name};
clear B


%% Mesh sanity checks
% NoCC = nan(NoS, NoB);
% for s=1:NoS
%     % Import the bones
%     load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
%     for b=1:length(B)
%         stats = statistics(B(b).mesh.vertices,B(b).mesh.faces);
%         sanityStats = rmfield(stats, {'num_faces', 'num_vertices', 'num_edges', ...
%             'num_connected_components', 'num_handles', 'euler_characteristic'});
%         if ~all(full(cell2mat(struct2cell(sanityStats)))==0)
%             error([Subjects.Number{s} ' (' num2str(s) '): ' B(b).name ' (' num2str(b) ')'])
%         end
%         NoCC(s,b) = stats.num_connected_components;
%     end
% end

% save('NumberOfConnComp.mat','NoCC')

%% Mesh volume
volume = nan(NoS, NoB);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
    for b=1:length(B)
        volume(s,b) = VolumeIntegrate(B(b).mesh.vertices,B(b).mesh.faces);
        % volume(s,b) = sum(arrayfun(@(x) meshVolume(x), splitMesh(B(b).mesh)));
    end
end

cmm3toccm3 = 0.001;
volumeTable = cell2table(cell(NoB,5), 'VariableNames', {'Bone name', 'Min.', 'Mean', 'Median', 'Max.'});
for b=1:NoB
    volumeTable(b,1) = boneNames(b);
    [minValue, minIdx(b)] = min(volume(:,b)*cmm3toccm3);
    volumeTable{b,2} = {minValue};
    volumeTable(b,3) = meanStats(volume(:,b)*cmm3toccm3,'% 1.0f','format','short');
    volumeTable(b,4) = medianStats(volume(:,b)*cmm3toccm3,'% 1.0f','format','short');
    [maxValue, maxIdx(b)] = max(volume(:,b)*cmm3toccm3);
    volumeTable{b,5} = {maxValue};
end

writetable(volumeTable, 'volumeResults.xlsx', 'Sheet','Volume', 'Range','B4',...
    'WriteVariableNames',0, 'WriteRowNames',0)

% bph = boxplot(volume,boneNames,'LabelOrientation','inline');
% set(findobj(get(bph(1), 'parent'), 'type', 'text'), 'interpreter','tex');

%% Number of vertices
NoV = nan(NoS, NoB);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
    for b=1:length(B)
        NoV(s,b) = size(B(b).mesh.vertices,1);
    end
end

figure('color','w')

bph = boxplot(NoV,boneNames,'LabelOrientation','inline');
set(findobj(get(bph(1), 'parent'), 'type', 'text'), 'interpreter','tex');