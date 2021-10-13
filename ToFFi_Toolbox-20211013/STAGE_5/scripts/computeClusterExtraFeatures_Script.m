clusterPointsIndices = find(singleRoiData.lvl2_gmm_pointsMembership == iCluster);

cfg = [];
tmp = [singleRoiData.lvl1_centroidsDuration{:}];
pointsTime      = tmp(clusterPointsIndices);
pointsSubjects  = singleRoiData.lvl1_centroidsSubjectIndices(clusterPointsIndices);

% cluster duration
singleRoiData.lvl2_gmm_centroidDuration(iCluster) = computeSingleClusterDuration(cfg, pointsTime, pointsSubjects);

% subjects that participate in that cluster
singleRoiData.lvl2_gmm_subjectsContributed{iCluster}  = unique(pointsSubjects);
singleRoiData.lvl2_gmm_nSubjectsPerCentroid(iCluster) = length(singleRoiData.lvl2_gmm_subjectsContributed{iCluster});
