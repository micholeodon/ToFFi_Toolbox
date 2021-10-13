function checkEvaluationSuccess(clusteringEvalObj)
%%
% Function that checks results of optimal number of clusters evaluation.
% Throws an error when any weird (infs, nans) or empty values are present.
%% Inputs
% *clusteringEvalObj* - struct with fields:
%
% _optNumClustersAllIter_ - double; 1D-array; contains positive integers that
%                           mean what number of clusters is optimal (separate
%                           number for each evaluation iteration).
%
% _criterionValues_ - double; 1D-array; contains positive integers that
%                     mean was the criterion value (e.g. silhouette
%                     criterion) for optimal number of cluster (separate
%                     value for each evaluation iteration).
%%

nIterations = size(clusteringEvalObj.optNumClustersAllIter, 1);

for iIteration = 1:nIterations
    kOpt    = clusteringEvalObj.optNumClustersAllIter(iIteration);

    is_kOptWeirdValue = isnan(kOpt) || isinf(kOpt) || isempty(kOpt);

    if is_kOptWeirdValue
	error([ 'Evaluation produced weird value of optimal number of clusters.',  ...
	    'Something is wrong with the points.',              ...
	    'Maybe they all lay in the same spot in space?']);

    end

    critVal = clusteringEvalObj.criterionValues(iIteration);

    isCriterionWeirdValue = isnan(critVal) || isinf(critVal) || isempty(critVal);

    if(isCriterionWeirdValue)
	error([ 'Evaluation produced NaN value of the criterion.',  ...
	    'Something is wrong with the points.',              ...
	    'Maybe they all lay in the same spot in space?']);
    end

end
