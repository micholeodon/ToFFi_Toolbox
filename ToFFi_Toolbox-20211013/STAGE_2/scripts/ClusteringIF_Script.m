% cluster Power kmeans
cfg = [];
cfg.distanceMetric  = CFG.STAGE_2.clustering.(CFG.STAGE_2.clusteringMethod).distanceMetric;
cfg.nReplicates     = CFG.STAGE_2.clustering.(CFG.STAGE_2.clusteringMethod).nReplicates;
cfg.nClusters       = numberOfClustersInThisRoi;
singleSubjectSingleRoiData = clusterPower_Kmeans(cfg, singleSubjectSingleRoiData);

% gaussian mixture modelling
cfg = [];
cfg.regularization      = CFG.STAGE_2.gaussianMixtureRegularization;
cfg.nClusters           = numberOfClustersInThisRoi;
if(isempty(jobInfo))
    jobPrefix = [];
else
    jobPrefix = ['job', num2str(jobInfo.jobID), '_'];
end
cfg.logPath             = ['../output/', jobPrefix];
individualFingerprintSingleROI  = gaussianMixtureModelling_IF(cfg, singleSubjectSingleRoiData);

% compute cluster duration
cfg = [];
cfg.nSpectralModesPerROI = numberOfClustersInThisRoi;
individualFingerprintSingleROI = computeClusterDuration(cfg, individualFingerprintSingleROI);

% add other fields
individualFingerprintSingleROI.numberOfClustersInThisRoi = numberOfClustersInThisRoi;
