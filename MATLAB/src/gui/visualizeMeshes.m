function varargout = visualizeMeshes(mesh, patchProps)
%VISUALIZEMESHES plots a struct array of meshes in a new figure
%
% AUTHOR: Maximilian C. M. Fischer
% 

if nargin == 1
    patchProps(1).EdgeColor = 'none';
    patchProps(1).FaceColor = [223, 206, 161]/255;
    patchProps(1).FaceAlpha = 1;
    patchProps(1).FaceLighting = 'gouraud';
end

if length(patchProps)==1
    patchProps=repmat(patchProps, length(mesh), 1);
end

% New figure
MonitorsPos = get(0,'MonitorPositions');
figHandle = figure('Units','pixels','renderer','opengl', 'Color', 'w');
if     size(MonitorsPos,1) == 1
    set(figHandle,'OuterPosition',[1 50 MonitorsPos(1,3)-1 MonitorsPos(1,4)-50]);
elseif size(MonitorsPos,1) == 2
    set(figHandle,'OuterPosition',[1+MonitorsPos(1,3) 50 MonitorsPos(2,3)-1 MonitorsPos(2,4)-50]);
end

axHandle = axes;
meshHandle=zeros(length(mesh),1);
for i=1:length(mesh)
    meshHandle(i) = patch(mesh(i), patchProps(i));
end

H_Light(1) = light; light('Position', -1*(get(H_Light(1),'Position')));
% cameratoolbar('SetCoordSys','none')
axis on; axis equal; hold on
xlabel x; ylabel y; zlabel z;

if nargout > 0
    varargout{1} = meshHandle;
    varargout{2} = axHandle;
    varargout{3} = figHandle;
end

end