function showOn3dBrain(roiToShow, colorIndices, sourceAtlas, colorMap, viewType)
% roiToShow - vector of ROI indices
% colorIndices - vector of values meaning which row of the colorMap
% argument assign to which ROI (colorIndices should be the same size as
% roiToShow)
% sourceAtlas - first output of the globalFunctionsScripts/prepareAtlas.m routine
% colorMap - array with rows containing RGB values for the colors to be
% used (values from 0.0 to 1.0)
% viewType - 'both' (draws both hemispheres), 'left' (draws only on the left hemisphere), 
% 'right' (draws only on the right hemisphere), 'slice' (draws on several brain axial cross-sections)

S_loadFieldtrip
S_loadTemplateMri

disp('Preparing template ...')
atlas           = sourceAtlas;            
atlas.coordsys  = 'mni';

atlas.selROIvoxels = zeros(size(atlas.tissue)); 
for roiIndex = roiToShow
    roiName = atlas.tissuelabel(roiIndex);
    % add subsequent selected ROIs voxel
    disp(['Adding ROI : ', num2str(roiIndex), ' ... (', atlas.tissuelabel(roiIndex), ') ...' ])  
    idx = find(atlas.tissue == roiIndex);
    atlas.selROIvoxels(idx) = atlas.tissue(idx);
end

% add another field remapping ROI indices to 
% to color indices (values argument)
atlas.selROInatural = atlas.selROIvoxels;
atlas.selROInatural = zeros(size(atlas.selROInatural)); % !
for ii = 1:numel(unique(roiToShow))
    atlas.selROInatural(atlas.selROIvoxels == roiToShow(ii)) = colorIndices(ii);
end

% sort roi be decreasing size - bigger will be plotted first, smaller will
% overlap them (overlap is present due to the interpolation that introduced blurring)
roiSize = zeros(1, numel(unique(roiToShow)));
for ii = 1:numel(roiToShow)
    iRoi = roiToShow(ii);
    roiSize(ii) = sum(sum(sum(atlas.selROIvoxels == iRoi)));
end

[~, idxSize]            = sort(roiSize, 'descend');
roiSortedBySize         = roiToShow(idxSize);
valuesSortedByRoiSize   = colorIndices(idxSize);
% we will interpolate roi one by one to combat interpolation artifacts
disp('Interpolate to atlas ...')
c = 0;
for ii = 1:numel(roiSortedBySize)
    c = c + 1;
    ii
    tmp = atlas;
    iRoi = roiSortedBySize(ii);
    
    tmp.selROInatural(tmp.selROIvoxels ~= iRoi) = 0; % mask out ROI other than iRoi
    cfg = [];
    cfg.parameter           = 'selROInatural';
    cfg.method              = 'nearest';
    tmp.selROInaturallabel  = tmp.tissuelabel; %% prevents fieldtrip from choking in ft_sourceinterpolate
    tmp.selROIvoxelslabel   = tmp.tissuelabel; %% prevents fieldtrip from choking in ft_sourceinterpolate
    tmp2                    = ft_sourceinterpolate(cfg, tmp, mri);
    idx                     = find(tmp2.selROInatural ~= 0);
    tmp2.selROInatural(idx) = valuesSortedByRoiSize(ii);
    if(c==1)
        chosenROI = tmp2;
        chosenROI.selROInatural = zeros(size(tmp2.selROInatural));
    end
    chosenROI.selROInatural(idx) = tmp2.selROInatural(idx);
end % for ii
chosenROI.selROInatural(isnan(chosenROI.selROInatural)) = 0;

% preparing pictures
S_plotView
