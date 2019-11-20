function medicalViewButtons(varargin)
%MEDICALVIEWBUTTONS adds 6 buttons with medical directions to a figure
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2016 - 2019 Maximilian C. M. Fischer
% LICENSE: EUPL v1.2
%

mode = 'RAS';

switch length(varargin)
    case 0
        hAx = gca;
    case 1
        if numel(varargin{1}) == 1 && ishandle(varargin{1})
            hAx = varargin{1};
        else
            hAx = gca;
            mode = varargin{1};
        end
    case 2
        hAx = varargin{1};
        mode = varargin{2};
end

% uicontrol Button Size
BSX = 0.1; BSY = 0.023;

%Font properies
FontPropsA.FontUnits = 'normalized';
FontPropsA.FontSize = 0.8;
% Rotate-buttons
switch mode
    case 'RAS'
        MC3D(:,:,1)=[0 1 0 0; -1 0 0 0; 0 0 1 0; 0 0 0 1];
        MC3D(:,:,2)=[0 -1 0 0; 1 0 0 0; 0 0 1 0; 0 0 0 1];
        MC3D(:,:,3)=[1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1];
        MC3D(:,:,4)=[-1 0 0 0;0 -1 0 0; 0 0 1 0; 0 0 0 1];
        MC3D(:,:,5)=[1 0 0 0;0 0 1 0; 0 -1 0 0; 0 0 0 1];
        MC3D(:,:,6)=[1 0 0 0;0 0 -1 0; 0 1 0 0; 0 0 0 1];
    case 'ASR'
        MC3D(:,:,1)=[1 0 0 0;0 0 -1 0; 0 1 0 0; 0 0 0 1];
        MC3D(:,:,2)=[-1 0 0 0;0 0 1 0; 0 1 0 0; 0 0 0 1];
        MC3D(:,:,3)=[0 0 1 0; 1 0 0 0; 0 1 0 0; 0 0 0 1];
        MC3D(:,:,4)=[0 0 -1 0; -1 0 0 0; 0 1 0 0; 0 0 0 1];
        MC3D(:,:,5)=[0 0 1 0;0 1 0 0; -1 0 0 0; 0 0 0 1];
        MC3D(:,:,6)=[0 0 1 0;0 -1 0 0; 1 0 0 0; 0 0 0 1];
    case 'SRA'
         MC3D(:,:,1)=[0 0 1 0;0 -1 0 0; 1 0 0 0; 0 0 0 1];
         MC3D(:,:,2)=[0 0 -1 0;0 1 0 0; 1 0 0 0; 0 0 0 1];
         MC3D(:,:,3)=[0 1 0 0;0 0 1 0; 1 0 0 0; 0 0 0 1];
         MC3D(:,:,4)=[0 -1 0 0;0 0 -1 0; 1 0 0 0; 0 0 0 1];
         MC3D(:,:,5)=[0 1 0 0; 1 0 0 0; 0 0 -1 0; 0 0 0 1];
         MC3D(:,:,6)=[0 1 0 0; -1 0 0 0; 0 0 1 0; 0 0 0 1];
end

mouseControl3d(hAx,MC3D(:,:,3))
hFig=get(hAx, 'parent');
uicontrol(hFig,'Units','normalized','Position',[0.5-BSX*3/2 0.01+BSY BSX BSY],FontPropsA,...
    'String','Left',     'Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,1)));
uicontrol(hFig,'Units','normalized','Position',[0.5-BSX*3/2     0.01 BSX BSY],FontPropsA,...
    'String','Right',    'Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,2)));
uicontrol(hFig,'Units','normalized','Position',[0.5-BSX*1/2 0.01+BSY BSX BSY],FontPropsA,...
    'String','Anterior', 'Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,3)));
uicontrol(hFig,'Units','normalized','Position',[0.5-BSX*1/2     0.01 BSX BSY],FontPropsA,...
    'String','Posterior','Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,4)));
uicontrol(hFig,'Units','normalized','Position',[0.5+BSX*1/2 0.01+BSY BSX BSY],FontPropsA,...
    'String','Superior', 'Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,5)));
uicontrol(hFig,'Units','normalized','Position',[0.5+BSX*1/2     0.01 BSX BSY],FontPropsA,...
    'String','Inferior', 'Callback',@(s,e) mouseControl3d(gca, MC3D(:,:,6)));

end