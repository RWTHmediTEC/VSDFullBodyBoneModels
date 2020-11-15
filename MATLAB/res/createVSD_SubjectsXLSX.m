clearvars; close all;

% Select the subjects for import
subjects = [1 9 13 19 23 24 27 35 36 42 46 49 50 55 56 57 61 62 64 66];

% Path of the VSD
dbPath = 'G:\sciebo\SMIR\VSDFullBody';
varNames = {'Number', 'Age', 'Sex', 'Weight', 'Height', 'Comment'};
mStruct = cell2struct(cell(length(varNames),1),varNames);
for s = 1:length(subjects)
    % Create the subject string
    mStruct(s).Number = ['z' num2str(subjects(s), '%03i')];
    files = dir([dbPath '\' mStruct(s).Number '\']);
    dirFlags = [files.isdir] & ~cellfun(@isempty, regexp({files.name}, 'Body'));
    if sum(dirFlags) == 1
        directory = files(dirFlags).name;
    else
        error('No subfolder found!')
    end
    
    metaTXT = [dbPath '\' mStruct(s).Number '\' directory '\' directory '.txt'];
    if ~exist(metaTXT, 'file')
        error(['File is missing: ' metaTXT])
    end
    fileID = fopen(metaTXT);
    txtLine{1,1} = fgetl(fileID);
    while ischar(txtLine{end,1})
        txtLine{end+1,1} = fgetl(fileID); %#ok<SAGROW>
    end
    fclose(fileID);
    txtLine = txtLine(1:end-1,1);
    if size(txtLine,1) ~= 30
        error(['Number of lines ~=30 of ' metaTXT])
    end
    % Age
    age = textscan(txtLine{find(strcmp(txtLine,'Age'))+1,1},'%f');
    if length(age) ~= 1
        error('Unexpected age value!')
    end
    mStruct(s).Age = age{1};
    % Comment
    comment = txtLine{find(strcmp(txtLine,'Comment'))+1,1};
    if length(comment) <= 1
        mStruct(s).Comment = [];
    else
        mStruct(s).Comment = strtrim(comment);
    end
    % Sex
    sex = regexp(txtLine{find(strcmp(txtLine,'Gender'))+1,1},'M|F','match');
    if isempty(sex) && length(comment) <= 1
        error('Unexpected sex value!')
    end
    mStruct(s).Sex = sex{1};
    % Weight
    weight = textscan(txtLine{find(strcmp(txtLine,'Weight'))+1,1},'%f');
    if length(weight) ~= 1
        error('Unexpected weight value!')
    end
    mStruct(s).Weight = weight{1};
    % Height
    height = textscan(txtLine{find(strcmp(txtLine,'Height'))+1,1},'%f');
    if length(height) ~= 1
        error('Unexpected height value!')
    end
    mStruct(s).Height = height{1};
    clearvars txtLine
end

writetable(struct2table(mStruct), 'VSD_Subjects.xlsx' ,'Range','B2', 'Sheet','VSD_Subjects')