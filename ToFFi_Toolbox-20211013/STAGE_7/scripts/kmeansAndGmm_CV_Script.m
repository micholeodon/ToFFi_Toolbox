% cluster Power kmeans
cfg = [];
cfg.distanceMetric  = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
cfg.nReplicates     = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates;
cfg.nClusters       = nClusters;
cfg.dataFieldName   = 'inputPoints';
cfg.prefixToFields  = '';
evalc('roiModel = cluster_Kmeans(cfg, roiModel)');


% gaussian mixture modelling
cfg = [];
cfg.regularization          = CFG.(STAGE_NAME).gaussianMixtureRegularization;
cfg.nClusters               = nClusters;
cfg.dataFieldName           = 'inputPoints';
cfg.startClustersFieldName  = 'kMeans_pointsClusterIndices';
cfg.prefixToFields          = '';
if(isempty(jobInfo))
    jobPrefix = [];
else
    jobPrefix = ['job', num2str(jobInfo.jobID), '_'];
end
cfg.logPath             = ['../output/', jobPrefix];
cfg.logColNames             = {'iSub', 'iRep', 'iFold', 'iROI'};
cfg.logColValues            = [iSub, iRep, iFold, iROI];
nPoints                     = size(roiModel.inputPoints,1);
nDim                        = size(roiModel.inputPoints,2);
if(nPoints <= nDim)
    cfg.initialModel.mu = roiModel.kMeans_centroids;
    cfg.initialModel.Sigma = [];
    cfg.initialModel.PComponents = [];
end
evalc('roiModel = gaussianMixtureModelling(cfg, roiModel)');
