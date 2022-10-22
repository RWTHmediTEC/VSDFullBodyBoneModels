function VSD_importData(Subject, dbPath)
%VSD_IMPORTDATA imports the data from the reconstructions of the VSD
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2022 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

% Settings
saveSwitch = false;
% Names of the bones
segNames={...
    'Sacrum','Hip_R','Hip_L','Femur_R','Femur_L','Patella_R','Patella_L',...
    'Tibia_R','Tibia_L','Fibula_R','Fibula_L','Talus_R','Talus_L',...
    'Calcaneus_R','Calcaneus_L','Tarsals_R','Tarsals_L',...
    'Metatarsals_R','Metatarsals_L','Phalanges_R','Phalanges_L'};

subjectString = Subject.ID{1};
boneFilename=['..\Bones\' subjectString '.mat'];

if exist(boneFilename, 'file')
    % Check for already existing data
    load(boneFilename,'B','M')
else
    for s=1:length(segNames)
        B(s).name = segNames{s};
        B(s).date='';
        B(s).mesh=[];
    end
    % Create empty meta struct
    M.notes={};
end

%% Meta data (M)
% Sex, age, weight, height, comment
M.sex = Subject.Sex{1};
M.age = Subject.Age(1);
M.weight = Subject.Weight(1);
M.height = Subject.Height(1);
M.notes = Subject.Comment{1};

%% Bone surface PLY files
files = dir([dbPath '\' subjectString '\']);
dirFlags = [files.isdir] &  ~cellfun(@isempty, regexp({files.name}, 'Models'));
if sum(dirFlags) == 1
    directory = files(dirFlags).name;
else
    error('No subfolder named ''Models'' was found!')
end

% Import bones (B)
tempFiles = dir([dbPath '\' subjectString '\' directory '\**\*.ply']);
if isempty(tempFiles)
    warning(['No PLY files were found in ' dbPath '\' subjectString '\' directory])
else
    for f=1:length(tempFiles)
        % Same order of the segs for each struct
        tempName = strrep(tempFiles(f).name, '.ply','');
        tempIdx = find(ismember(segNames, tempName));
        if ~isempty(tempIdx)
            % Replace if mesh date is different
            importFlag = true;
            if tempIdx <= length(B)
                importFlag = ~strcmp(B(tempIdx).date, tempFiles(f).date);
            end
            if importFlag
                meshPath = fullfile(tempFiles(f).folder, tempFiles(f).name);
                disp(['Importing ' meshPath])
                % Date
                B(tempIdx).date = tempFiles(f).date;
                % Import mesh
                tempMesh = readMesh(meshPath);
                % Import only the outer surface
                tempMesh = keepOnlyOuterSurface(tempMesh);
                % Remove components below 25 vertices
                tempMesh = tempMesh(arrayfun(@(x) size(x.vertices,1), tempMesh)>=25);
                % Remove components with a volume below 1 mm³
                tempMesh = tempMesh(arrayfun(@(x) meshVolume(x), tempMesh)>=1);
                % Optimize mesh
                for m=1:length(tempMesh)
                    tempMesh(m) = VSD_optimizeMeshWrapper(tempMesh(m));
                end
                B(tempIdx).mesh = tempMesh;
                if length(B(tempIdx).mesh)>1
                    warning(['Multi-component bone: ' num2str(length(B(tempIdx).mesh)) ' components!'])
                    B(tempIdx).mesh = concatenateMeshes(B(tempIdx).mesh);
                end
                saveSwitch=true;
            end
            % Copy name of the bone
            if ~strcmp(B(tempIdx).name, segNames{tempIdx}) || isa(B(tempIdx).name,'cell')
                B(tempIdx).name = segNames{tempIdx};
                saveSwitch = true;
            end
        end
        if saveSwitch
            save(boneFilename,'B','M')
        end
        saveSwitch=false;
    end
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