kListLength = length(CFG.STAGE_2.NumClustEval_kList);
clusteringEvaluation.optNumClustersAllIter    = nan(1, CFG.STAGE_2.NumClustEval_nIterations);
clusteringEvaluation.criterionValues          = nan(1, CFG.STAGE_2.NumClustEval_nIterations);

disp('Calculating optimal number of clusters !');

dataToTest = singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials;

evaluateClustersNumber_Script

% check results
checkEvaluationSuccess(clusteringEvaluation)
disp('Silhouette done !');
