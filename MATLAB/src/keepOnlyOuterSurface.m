function meshOut = keepOnlyOuterSurface(meshIn)
%KEEPONLYOUTERSURFACE preserves only outer surfaces of a mesh
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2021 Maximilian C. M. Fischer
% LICENSE: CC BY-NC-SA
%

tempMesh = trimMesh(meshIn.vertices, meshIn.faces);
tempMeshes = splitMesh(tempMesh);

% Get bounding boxes of the meshes
bBoxes = cell2mat(arrayfun(@(x) boundingBox3d(x.vertices), tempMeshes,'uni',0));
% Number of bounsing boxes
NoB = size(bBoxes,1);
% Preallocate indices of the outer surfaces
outerSurfaceIdx = true(NoB,1);
if NoB == 1
    warning('Mesh does not contain a inside surface')
else
    % Check if bounding box is inside another bounding box
    for b=1:NoB
        for bb=1:NoB
             if isBoundingBoxInside(bBoxes(bb,:), bBoxes(b,:))
                 % If yes, it is not an outer surface
                 outerSurfaceIdx(b) = false;
             end
        end
    end   

end

% Save only the outer surface
meshOut = tempMeshes(outerSurfaceIdx);

end

function isInside = isBoundingBoxInside(bBoxOut, bBoxIn)
% Check if bBoxIn is inside of bBoxOut
isInside = false;
if bBoxOut(1) < bBoxIn(1) && bBoxOut(2) > bBoxIn(2) ...
        && bBoxOut(3) < bBoxIn(3) && bBoxOut(4) > bBoxIn(4) ...
        && bBoxOut(5) < bBoxIn(5) && bBoxOut(6) > bBoxIn(6)
    isInside = true;
end
end