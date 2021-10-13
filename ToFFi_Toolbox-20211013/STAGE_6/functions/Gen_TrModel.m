function roiModel = Gen_TrModel(CFG, MODE, data)
%%
% Function used to wrap piece of code responsible for perform training of
% single ROI.
%%
STAGE_NAME = data.STAGE_NAME;
iRep = data.iRep;
iFold = data.iFold;
iROI = data.iROI;
trSub = data.trSub;
nSubTr = numel(trSub);
pooledClusters = data.pooledClusters;
nClustersPerRoi = data.nClustersPerRoi;

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas = numel(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
goodROI = CFG.Global.goodROI;

roiModel            = [];
roiModel.iROI       = data.iROI;
roiModel.nRoiAtlas  = nRoiAtlas;
roiModel.goodROI    = goodROI;

cfg = [];
cfg.selectedSubjectIndices = trSub;
evalc(['[roiModel.centroidsFromTrSub, ', 'idxInPooledClustersSingleRoi, ', ...
    'roiModel.centroidsTrSubIndices] = get_selectedSubjectsCentroids(cfg, pooledClusters(iROI))']);

% if 'mode' then calculate number of clusters
switch(CFG.(STAGE_NAME).nClustersSetting)
    case 'mode'
	for s = 1:nSubTr
	    iSub = trSub(s);
	    numClustPerSub(s) = sum(roiModel.centroidsTrSubIndices == iSub);
	end
    nonZeroIdx = find(numClustPerSub > 0);
	nClustersPerRoi{iROI} = mode(numClustPerSub(nonZeroIdx));

    otherwise
	% leave nClustersPerRoi variable intact
end

roiModel = kmeansAndGmm_CV(CFG, nClustersPerRoi{iROI}, roiModel, data);

% note down which clusters are not represented by majority of subjects, but do not truncate them yet
% and note cluster duration
nClusters = nClustersPerRoi{iROI};
roiModel.centroidDuration = zeros(1, nClusters); 
roiModel.nSubPerCentroid = zeros(1, nClusters); 
durationPooledClustersSingleRoi = [pooledClusters(iROI).centroidsDuration{:}];
for iCluster = 1:nClusters
    clusterIndices = find(roiModel.gmm_pointsMembership == iCluster);
    % cluster subjects
    pointsSubjects = roiModel.centroidsTrSubIndices(clusterIndices);
    roiModel.subjectsPerCentroid{iCluster} = unique(pointsSubjects);
    roiModel.nSubPerCentroid(iCluster) = numel(roiModel.subjectsPerCentroid{iCluster});
    % cluster times
    pointsTime = durationPooledClustersSingleRoi(idxInPooledClustersSingleRoi(clusterIndices));
    roiModel.centroidDuration(iCluster) = computeSingleClusterDuration([], pointsTime, pointsSubjects);
end
roiModel.nonPopularModeFlags = roiModel.nSubPerCentroid < CFG.(STAGE_NAME).majoritySubjectNum;
