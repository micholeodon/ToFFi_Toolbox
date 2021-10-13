nIterations = CFG.(STAGE_NAME).NumClustEval_nIterations;

kListLength = length(CFG.(STAGE_NAME).NumClustEval_kList);
clusteringEvaluation.optNumClustersAllIter    = nan(1, CFG.(STAGE_NAME).NumClustEval_nIterations);
clusteringEvaluation.criterionValues          = nan(1, CFG.(STAGE_NAME).NumClustEval_nIterations);

disp('Calculating optimal number of clusters !');
dataToTest = data.points;

evaluateClustersNumber_Script

% check results
checkEvaluationSuccess(clusteringEvaluation)
