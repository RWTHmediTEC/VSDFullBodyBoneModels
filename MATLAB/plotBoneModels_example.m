%PLOTBONEMODELS_EXAMPLE provides an example how to plot the VSD subjects.
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2022-2023 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

clearvars; close all; opengl hardware

addpath(genpath('src'))

Subject = '002';

patchProps.FaceAlpha = 0.5;
load(['..\Bones\' Subject '.mat'], 'B')
visualizeMeshes([B(1:end).mesh],patchProps)
anatomicalViewButtons('LPS')
axis off tight; view(0,0);
set(gcf,'Name',['VSD subject: ' Subject],'NumberTitle','off')
title('Scroll click: Rotate | Scroll: Zoom | Right click: Pan')

% [List.f, List.p] = matlab.codetools.requiredFilesAndProducts([mfilename '.m']);
% List.f = List.f'; List.p = List.p';