PC_FOLDER_IDX = 1;
SF_FOLDER_IDX = 2;


% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
roiLabels    = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
nRoiAtlas       = numel(roiLabels);
goodROI         = CFG.Global.goodROI;
nGoodROI        = numel(goodROI);

fitMatrix   = nan(nRoiAtlas, nRoiAtlas);

singleRoiPooledPointsFile = [CFG.(STAGE_NAME).inputDataFolder{PC_FOLDER_IDX}, CFG.STAGE_8.pooledClustersFileNamePrefix, '.mat'];
load(singleRoiPooledPointsFile);
