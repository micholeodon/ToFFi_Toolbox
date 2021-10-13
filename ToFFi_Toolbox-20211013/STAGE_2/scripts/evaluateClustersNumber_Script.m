cfg = [];
cfg.metric = CFG.(STAGE_NAME).NumClustEval_distanceMetric;
if(isOneCluster(cfg, dataToTest))
    addpath([CFG.Global.rootDir, CFG.Global.toolsDir, 'HZmvntest/'])
    disp('Single cluster !')
    clusteringEvaluation.optNumClustersAllIter(:) = 1;
    clusteringEvaluation.criterionValues(:) = 1;
else
    disp('Multiple clusters !')
    switch MODE
        case 'serial'
            SerialSilhouette_Script
        case 'parallel'
            ParallelSilhouette_Script
        otherwise
            error('ERROR: Wrong value of MODE !');
    end % switch MODE
end