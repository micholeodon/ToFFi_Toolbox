% how many clusters ?
switch CFG.(STAGE_NAME).numberOfClusters
  case 'optimal'
    nClust = clusteringEvaluationAllROI(iROI).optimalNumClusters;
  otherwise
    nClust = CFG.STAGE_5.numberOfClusters;
end

% cluster Power kmeans
cfg = [];
cfg.distanceMetric  = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
cfg.nReplicates     = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates;
cfg.nClusters       = nClust;
cfg.dataFieldName   = 'lvl1_centroidsFromAllSubjects';
cfg.prefixToFields  = 'lvl2_';
singleRoiData = cluster_Kmeans(cfg, singleRoiData); % k-means in original version

% gaussian mixture modelling
cfg = [];
cfg.regularization      = CFG.(STAGE_NAME).gaussianMixtureRegularization;
cfg.nClusters           = nClust;
cfg.dataFieldName       = 'lvl1_centroidsFromAllSubjects';
cfg.startClustersFieldName = 'lvl2_kMeans_pointsClusterIndices';
cfg.prefixToFields      = 'lvl2_';
if(isempty(jobInfo))
    jobPrefix = [];
else
    jobPrefix = ['job', num2str(jobInfo.jobID), '_'];
end
cfg.logPath             = ['../output/', jobPrefix];
cfg.logColNames         = {'iROI'};
cfg.logColValues        = iROI;
nPoints                 = size(singleRoiData.lvl1_centroidsFromAllSubjects,1);
nDim                    = size(singleRoiData.lvl1_centroidsFromAllSubjects,2);
if(nPoints <= nDim)
    cfg.initialModel.mu = singleRoiData.lvl2_kMeans_centroids;
    cfg.initialModel.Sigma = [];
    cfg.initialModel.PComponents = [];
end
singleRoiData           = gaussianMixtureModelling(cfg, singleRoiData);

% Sometimes (it is not known why) two or more clusters overlap
% and as a result some of them has zero points assigned.
