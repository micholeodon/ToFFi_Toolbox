function clusteringEvaluationOneROI = serialProcessing(CFG, dataToTest, clusteringEvaluationOneROI)
%%
% Performs optimal number of clusters evaluation using selected method,
% clustering algorithm and metric. Calculations are performed as sequential
% computations.
%
%% Inputs
% *dataToTest* - double; 2D-array of size points x dimensions. Contains
%                points that will be clustered to test which number of
%                clusters is optimal. It represents spectral modes for single
%                ROI from all individual subjects from STAGE_2 that were
%                pooled together in STAGE_3.
%
% *CFG* - struct with obligatory fields:
%
% _STAGE_4.nIterations_ - double; positive integer number of iterations of
%                         evaluation.
%
% _STAGE_4.methodName_ - char; name of the clustering algorithm to be used in
%                        evaluation.Possible options:
% https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-clust
%
% _STAGE_4.criterionType_ - char; name of the criterion type to be used in
%                           evaluation. Possible options:
% https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion
%
% _STAGE_4.kList_ - double; 1D-array of integers > 0. List of number of
%                   cluster values to be tested in evaluation.
%
% _STAGE_4.distanceMetric_ - char; metric used to calculate distance between
%                            points. Possible values:
% https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-Distance
%
% *clusteringEvaluationOneROI* - struct storing results of optimal cluster
%                                number evaluation for each iteration. Has
%                                fields:
%
% _optNumClustersAllIter_ - double; 1D-vector of size 1 x iterations. For
%                           each planned iteration it will store optimal
%                           number of clusters computed for each iteration.
%
% _criterionValues_ - double; 1D-vector of size 1 x iterations. For each
%                     planned iteration it will store selected criterion
%                     value corresponding to the optimal number of clusters
%                     computed at that iteration.
%% Outputs
% *clusteringEvaluationOneROI* - same as in input but updated by the data
%                                from all planned iterations.
%%

for iIteration = 1:CFG.STAGE_4.nIterations
    disp(['Num. Clust. Evaluation: Iteration ', num2str(iIteration), ' / ', num2str(CFG.STAGE_4.nIterations), ' ...' ]);
    evalutationObject = evalclusters( dataToTest, ...
	CFG.STAGE_4.methodName, ...
	CFG.STAGE_4.criterionType, ...
	'klist',    CFG.STAGE_4.kList, ...
	'Distance', CFG.STAGE_4.distanceMetric);

    clusteringEvaluationOneROI.optNumClustersAllIter(iIteration)    = evalutationObject.OptimalK;
    idx = find(evalutationObject.InspectedK == evalutationObject.OptimalK);
    clusteringEvaluationOneROI.criterionValues(iIteration)          = evalutationObject.CriterionValues(idx);
end % iIteration
