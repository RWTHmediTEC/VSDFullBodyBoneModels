function VSD_importData(Subject, dbPath)
%VSD_IMPORTDATA imports the data from the VSD
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2020 Maximilian C. M. Fischer
% LICENSE: CC BY-NC-SA
%

% settings
saveSwitch = false;
% names of the bones
segNames={'Sacrum','Hip_R','Hip_L','Femur_R','Femur_L'};

subjectString = Subject.Number{1};
boneFilename=['..\Bones\' subjectString '.mat'];

if exist(boneFilename, 'file')
    % check for previous data
    load(boneFilename,'B','M')
else
    for s=1:length(segNames)
        B(s).name=segNames{s};
        B(s).date='';
        B(s).mesh=[];
    end
    % create empty meta struct
    M.notes={};
end

files = dir([dbPath '\' subjectString '\']);
dirFlags = [files.isdir] & ~cellfun(@isempty, regexp({files.name}, 'Body'));
if sum(dirFlags) == 1
    directory = files(dirFlags).name;
else
    error('No subfolder found!')
end

% Import bones (B)
tempFiles = dir([dbPath '\' subjectString '\' directory '\*.ply']);
if ~isempty(tempFiles)
    for f=1:length(tempFiles)
        % Same order of the segs for each struct
        tempName = strrep(tempFiles(f).name, '.ply','');
        tempIdx = find(ismember(segNames, tempName));
        if ~isempty(tempIdx)
            % replace if mesh date is different
            if ~strcmp(B(tempIdx).date, tempFiles(f).date)
                disp(['Importing ' subjectString '\' directory '\' tempName '.ply'])
                % date
                B(tempIdx).date=tempFiles(f).date;
                % import mesh
                [B(tempIdx).mesh.vertices, B(tempIdx).mesh.faces] = ...
                    readPLY(fullfile(tempFiles(f).folder, tempFiles(f).name));
                % optimze mesh
                B(tempIdx).mesh = VSD_optimizeMeshWrapper(B(tempIdx).mesh);
                
                saveSwitch=true;
            end
        end
    end
end

%% Meta data (M)
% sex, age
M.sex = Subject.Sex{1};
M.age = Subject.Age(1);
M.weight = Subject.Weight(1);
M.height = Subject.Height(1);
M.notes = Subject.Comment{1};

if saveSwitch
    save(boneFilename,'B','M')
end

%% Import pelvis volume
% tempFiles = dir([dbPath '\' subjectString '\' directory '\*.nrrd']);
% volumeIdx=~cellfun(@isempty, regexp({tempFiles.name}, 'WinSinc-1000'));
% if sum(volumeIdx)==1
%     volMatFile=['..\Volumes\' subjectString '_pelvisVolume.mat'];
%     if exist(volMatFile, 'file')
%         load(volMatFile, 'date')
%     else
%         date='';
%     end
%     if ~strcmp(date, tempFiles(volumeIdx).date)
%         pelvisVolume = nhdr_nrrd_read(fullfile(tempFiles(volumeIdx).folder, tempFiles(volumeIdx).name), true);
%         date=tempFiles(volumeIdx).date;
%         save(volMatFile, 'pelvisVolume', 'date')
%     end
% end

end