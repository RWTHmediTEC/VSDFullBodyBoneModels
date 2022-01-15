function meshOut = keepOnlyOuterSurface(meshIn)
%KEEPONLYOUTERSURFACE preserves only outer surfaces of a mesh
%
% AUTHOR: Maximilian C. M. Fischer
% COPYRIGHT (C) 2021 Maximilian C. M. Fischer
% LICENSE: CC BY-NC-SA
%

tempMesh = trimMesh(meshIn.vertices, meshIn.faces);
tempMeshes = splitMesh(tempMesh);

% Number of meshes
NoM = size(tempMeshes,1);
if NoM == 1
    warning('Mesh does not contain a inside surface')
    return
end

% Orient all meshes outwards
for m=1:NoM
    tempMeshes(m).faces = orient_outward(tempMeshes(m).vertices, tempMeshes(m).faces);
end

% Get bounding boxes of the meshes
bBoxes = cell2mat(arrayfun(@(x) boundingBox3d(x.vertices), tempMeshes,'uni',0));

% Preallocate indices of the outer surfaces
outerSurfaceIdx = true(NoM,1);

% Check if bounding box of one mesh is inside the bounding box of another mesh
for m=1:NoM
    for mm=1:NoM
        if isBoundingBoxInside(bBoxes(mm,:), bBoxes(m,:))
            % If yes, check if all vertices are inside the other mesh
            isInside = signed_distance(tempMeshes(m).vertices, tempMeshes(mm).vertices, tempMeshes(mm).faces);
            if isempty(isInside)
                error('Cannot be empty');
            elseif all(0>isInside)
                outerSurfaceIdx(m) = false;
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