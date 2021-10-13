function roiModel = Gen_TrModel_S7(CFG, MODE, data)
%%
% Function used to wrap piece of code responsible for perform training of
% single ROI.
%%

STAGE_NAME = data.STAGE_NAME;
iRep  = data.iRep;
iFold = data.iFold;
iROI  = data.iROI;
iSub = data.iSub;
jobInfo = data.jobInfo;


% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas = numel(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
goodROI = CFG.Global.goodROI;

roiModel            = [];
roiModel.iROI       = data.iROI;
roiModel.nRoiAtlas  = nRoiAtlas;
roiModel.goodROI    = goodROI;
roiModel.inputPoints = data.points;

% if 'mode' then calculate number of clusters
switch(CFG.(STAGE_NAME).nClustersSetting)
  case 'fixed'
	nClusters = CFG.(STAGE_NAME).fixed_nClusters;
  case 'optimal'
	OptimalClusters_Script

	% choose best and save as a separate field
	nClusters = mode(clusteringEvaluation.optNumClustersAllIter);

  otherwise
	error('ERROR: Unrecognized value of nClustersSetting in CFG !')
end % switch

kmeansAndGmm_CV_Script
