disp('Checking names ...')

if(~exist('pooledClusters', 'var'))
    error('Incorrect loaded pooledClusters variable name');
end

if(~exist('clusteringEvaluationAllROI', 'var'))
    error('Incorrect loaded clusteringEvaluationAllROI variable name');
end
