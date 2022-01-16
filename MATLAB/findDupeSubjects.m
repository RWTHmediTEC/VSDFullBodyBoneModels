clearvars; close all; opengl hardware

addpath(genpath('src'))

load('res\VSD_Subjects.mat', 'Subjects')

%% Import
NoS = size(Subjects, 1);
patchProps.FaceAlpha = 0.5;
TFM2 = repmat(struct('APP',[]),NoS,1);
Sacrum = repmat(struct('vertices',[],'faces',[]),NoS,1);
for s=1:NoS
    % Import the bones
    load(['..\Bones\' Subjects.Number{s} '.mat'], 'B')
    % Import the transformation to the APP coordinate system
    load(['D:\Biomechanics\Hip\Code\AcetabularMorphologyAnalysis\data\' Subjects.Number{s} '.mat'], 'TFM2APP')
    TFM2(s).APP=TFM2APP;
    % Transform the sacrum to the APP coordinate system
    Sacrum(s)=transformPoint3d(B(1).mesh,TFM2(s).APP*anatomicalOrientationTFM('LPS', 'RAS'));
end
clearvars B TFM2APP

% Compare the sacrum of each subject using an ICP registration
patchProps.FaceAlpha = 0.5;
SS = 1:NoS;
rigidRegRMSE = nan(NoS);
for s=1:NoS
    SS(SS==s)=[];
    for ss=SS
        rigidReg = icp(Sacrum(s),Sacrum(ss),'Plot',true,'ChangeRate',1e-2,'Delay',0);
        rigidRegRMSE(s,ss) = rigidReg.rmse;
    end
end

% save('rigidRegRMSE','rigidRegRMSE')

%% Evaluate results
load('rigidRegRMSE','rigidRegRMSE')

medianRMSE = median(rigidRegRMSE(:), 'omitnan');
outlierCutOff = prctile(rigidRegRMSE(:),25)-1.5*iqr(rigidRegRMSE(:));
[row,col] = ind2sub(size(rigidRegRMSE),find(rigidRegRMSE<outlierCutOff));
for d=1:length(row)
    disp([...
        'Subject ' Subjects.Number{row(d)} ' and ' Subjects.Number{col(d)} ...
        ' are dupes based on a comparison of the sacrum!'])
end

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';