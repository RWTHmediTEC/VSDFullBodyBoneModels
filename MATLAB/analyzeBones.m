clearvars; close all; opengl hardware

addpath(genpath('src'))
VSD_addPathes('..\..\..\..\')

% Load subjects & meta data
subjectXLSX = 'res\VSD_Subjects.xlsx';
[~, ~, metaData] = xlsread(subjectXLSX);
Subjects = cell2table(metaData(2:end,:),'VariableNames',metaData(1,:));
NoS = size(Subjects, 1);

load(['..\Bones\' Subjects.Number{1} '.mat'], 'B')
NoB = length(B); clear B

%% Mesh sanity checks
NoCC = nan(NoS, NoB);
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
% 
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