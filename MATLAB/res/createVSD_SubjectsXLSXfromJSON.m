%CREATEVSD_SUBJECTSXLSXFROMJSON creates a subjects excel file.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all;

% Select the subjects for import
subjects = {'002'; '006'; '010'; '014'; '015'; '016'; '017'; '019'; '023';'z001';...
    'z004'; 'z009'; 'z013'; 'z019'; 'z023'; 'z027'; 'z035'; 'z036'; 'z042'; 'z046'; ...
    'z049'; 'z050'; 'z055'; 'z056'; 'z057'; 'z061'; 'z062'; 'z063'; 'z064'; 'z066'};

% Path of the VSD
dbPath = 'D:\sciebo\SMIR\VSDFullBodyBoneReconstruction';

varNames = {'ID', 'Age', 'Sex', 'Weight', 'Height'};
NoS = length(subjects);
subjectData = table(subjects,nan(NoS,1),cell(NoS,1),nan(NoS,1),nan(NoS,1),...
    'VariableNames',{'ID','Age','Sex','Weight','Height'});
for s = 1:length(subjects)
    % Find JSON files
    files = dir([dbPath '\' subjects{s} '\**\*.json']);
    files(cellfun(@(x) contains(x,'.mrk.'), {files.name}))=[];
    
    metaData = cell(length(files),4);
    for f=1:length(files)
        fileName = fullfile(files(f).folder, files(f).name);
        jsonData = jsondecode(fileread(fileName));
        metaData{f,1} = subjects{s};
        metaData{f,2} = jsonData.subjectSnapshot.ageInDays/365;
        metaData{f,3} = jsonData.subjectSnapshot.gender.name;
        metaData{f,4} = jsonData.subjectSnapshot.weightInKilograms;
        if isempty(metaData{f,4})
            metaData{f,4} = nan;
        else
            metaData{f,4} = round(metaData{f,4},2);
        end
        metaData{f,5} = jsonData.subjectSnapshot.heightInMeters;
        if isempty(metaData{f,5})
            metaData{f,5} = nan;
        else
            metaData{f,5} = round(metaData{f,5},2);
        end
    end
    metaData = unique(cell2table(metaData,'VariableNames',{'ID','Age','Sex','Weight','Height'}));
    subjectData(s,:) = metaData(1,:);
end

writetable(subjectData, 'VSD_SubjectsFromJSON.xlsx' ,'Range','B3',...
    'Sheet','VSD_Subjects','WriteVariableNames',0)