function [inside_idx, tissue_idx] = getRoiInsideIndices(roi, sourceAtlasSingle, sourceModel)
%%
% Gets array of indices of voxels that are labeled by the selected ROI.
%
%% Inputs
% *roi* - double; integer index of single chosen ROI
%         or
%         char; name of single chosen ROI (one of the names inside
%         *sourceAtlasSingle.tissuelabel* field)
%
% *sourceModel* - struct; output of prepareSourceModel.m routine
%
% *sourceAtlasSingle* - struct; single structure from output structure array
%                       sourceAtlas of prepareAtlas.m routine  
%% Outputs
% *inside_idx* - double; array of integer indices from 'inside' structure
%                field of a *sourceModel* corresponding to selected ROI.
%
% *tissue_idx* - double; array of integer indices from 'tissue' structure
%                field of a *sourceModel* corresponding to selected ROI.
%%

if(ischar(roi))
    ROIbyName = 1;
    ROIbyNr   = 0;
elseif(isa(roi,'double'))
    ROIbyName = 0;
    ROIbyNr   = 1;
else
    ROIbyName = 0;
    ROIbyNr   = 0;
    error('Variable roi is of unrecognized class ...')
end

if ROIbyName
    roiNr = find(ismember(sourceAtlasSingle.tissuelabel, roi));
    roiName = roi;
elseif ROIbyNr
    roiNr = roi;
    roiName = sourceAtlasSingle.tissuelabel{roiNr};
else
    error('Code error!')
end


if strcmp(roiName, 'nonroi')
    check_dipole_matrix = nan(1, length(sourceModel.inside));
    for iROI = 1:length(sourceAtlasSingle.tissuelabel)
        % check-out all ROI voxel to left non-ROI voxels unchecked
        selROIvoxels  = double(sourceAtlasSingle.tissue == iROI);
        tissue_idx    = (find(selROIvoxels == 1)');
        idx = find(ismember(sourceModel.inside, tissue_idx));
        if(isnan(check_dipole_matrix(idx))) % checks out all roi voxels so only non roi voxel will be left nan
            check_dipole_matrix(idx) = 1;
        else
            check_dipole_matrix(idx) = check_dipole_matrix(idx) + 1;
        end
    end
    
    inside_idx = find(isnan(check_dipole_matrix)); % indices of voxels that not belong to any roi but are still inside brain
    
else
    selROIvoxels  = double(sourceAtlasSingle.tissue == roiNr);
    tissue_idx    = (find(selROIvoxels == 1)');
    inside_idx = find(ismember(sourceModel.inside, tissue_idx));
end
