cfg = [];
cfg.metric = CFG.(STAGE_NAME).distanceMetric;
if(isOneCluster(cfg, dataToTest))
    addpath([CFG.Global.rootDir, CFG.Global.toolsDir, 'HZmvntest/'])
    disp('Single cluster !')
    clusteringEvaluationOneROI.optNumClustersAllIter(:) = 1;
    clusteringEvaluationOneROI.criterionValues(:) = 1;
else
    disp('Multiple clusters !')

    switch MODE
      case 'serial'
        clusteringEvaluationOneROI = serialProcessing(CFG, dataToTest, clusteringEvaluationOneROI);
      case 'parallel'
        clusteringEvaluationOneROI = parallelProcessing(CFG, ...
                                                        dataToTest, clusteringEvaluationOneROI, jobInfo);
      otherwise
        error('ERROR: Wrong value of MODE !');
    end % switch MODE
end