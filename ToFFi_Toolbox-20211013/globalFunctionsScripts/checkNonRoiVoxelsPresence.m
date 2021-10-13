function areNonRoiVoxelPresent = checkNonRoiVoxelsPresence(sourceAtlasAndSourceModelStructure)
%%
% Checks if given source atlas has any inside voxel that are not assigned to
% any ROI from atlas.
%% Inputs
% *sourceAtlasAndSourceModel* - struct with fields:
%
%     _sourceModel_ - struct; output of prepareSourceModel.m routine
%
%     _sourceAtlas_ - struct; output of prepareAtlas.m routine
%% Outputs
% *areNonRoiVoxelPresent* - double; 0 (all voxels from atlas has assigned
%                           ROI) or 1 (there are voxels that have no assigned
%                           ROI).
%%

sourceAtlas = sourceAtlasAndSourceModelStructure.sourceAtlas;
sourceModel = sourceAtlasAndSourceModelStructure.sourceModel;

nAtlases = numel(sourceAtlas);
for iAtlas = 1:nAtlases
    idx = getRoiInsideIndices('nonroi', sourceAtlas(iAtlas), sourceModel);
    
    if(isempty(idx))
        areNonRoiVoxelPresent = 0;
    else
        areNonRoiVoxelPresent = 1;
        warning(['Atlas nr ', num2str(iAtlas), ' contains non-ROI voxels !']);
        break;
    end
end
