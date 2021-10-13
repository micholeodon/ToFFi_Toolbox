function inputStructure = cluster_Kmeans(cfg, inputStructure)
%%
% Performs K-means clustering on the multidimensional data. Uses standard
% MATLAB kmeans routine with additional improvements:
%
% - initial sorting (result is invariant to the order of rows of the data matrix)
%
% - post-relabeling (for given solution labels are always the same,
%   see reNumerateClusters.m for further explanation).
%% Inputs
% *cfg* - struct with fields:
%
% _distanceMetric_ - char; metric that will be used to compute
%                    distance between data points. Possible choices:
% https://www.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans&s_tid=srchtitle#buefs04-Distance
%
% _nReplicates_ - double; integer number of times to repeat clustering using
%                 new initial cluster centroid positions. Solution with the
%                 lowest within-cluster sums of point-to-centroid distances
%                 will be chosen as the final one.
%
% _nClusters_ - double; integer number of clusters to be found in the data.
%
% _dataFieldName_ - char; name of the field in the *inputStructure*
%                   containing data matrix to be clustered
%
% _prefixToFields_ - (optional) char; prefix that will be added at the
%                    beginning of each new field created in the
%                    *inputStructure*, e.g. if _prefixToFields_ = 'lvl1_',
%                    following fields will be added to *inputStructure*:
%                    _lvl1_kMeans_pointsClusterIndices_,
%                    _lvl1_kMeans_centroids_,
%                    _lvl1_kMeans_withinClusterDistance_.
%
% *inputStructure* - struct with single obligatory field containing data to
%                    be clustered. This data field should have same name as
%                    name stored in *cfg.dataFieldName*. Data should be a
%                    double 2D-array of size N x D, where N is the number of
%                    observations to be clustered and D is the number of
%                    dimensions / variables.
%% Outputs
% **inputStructure** - same struct as in input but containing additional fields:
%
% _kMeans_pointsClusterIndices_ - double; 1D-array containing cluster index
%                                 for each of the clustered points in the
%                                 input data matrix. Contain values from 1 to
%                                 cfg.nClusters.
% _kMeans_centroids_ - double; 2D-array of size cfg.nClusters x D, where D is
%                      the number of dimensions / variables . Each row
%                      contains single cluster center (centroid).
%
% _kMeans_withinClusterDistance_ - double; 1D-array of within-cluster sums of
%                                  point-to-centroid distances.
%%

display('K-means clustering ...')

% checks
if(~isfield(cfg, 'distanceMetric')) error('Missing field distanceMetric in cfg input argument !'); end
if(~isfield(cfg, 'nReplicates'))    error('Missing field nReplicates in cfg input argument !');  end
if(~isfield(cfg, 'nClusters'))    error('Missing field nClusters in cfg input argument !');  end
if(~isfield(cfg, 'dataFieldName'))    error('Missing field dataFieldName in cfg input argument !');  end


if(~isfield(cfg, 'prefixToFields'))
    prefix = '';
elseif(isempty(cfg.prefixToFields))
    prefix = '';
else
    prefix = cfg.prefixToFields;
end

% init new fields
inputStructure.([prefix, 'kMeans_pointsClusterIndices'])     = [];
inputStructure.([prefix, 'kMeans_centroids'])                = [];
inputStructure.([prefix, 'kMeans_withinClusterDistance'])    = [];

displayOption   = statset('Display','final');
dataToCluster = inputStructure.(cfg.dataFieldName);

if(size(dataToCluster,1) <= cfg.nClusters)
    error('Error: There should be more points to cluster than demanded number of clusters !');
end

% sort
[dataToCluster_sorted, sortedOrder] = sortrows(dataToCluster); 
waste_txt_output = evalc(['[clusterID_sorted, centroids, withinClusterDistance] = kmeans( dataToCluster_sorted, cfg.nClusters,' ...
    ' ''Options'', displayOption,' ...
    ' ''Distance'', cfg.distanceMetric,' ...
    ' ''Replicates'', cfg.nReplicates);']);
clear waste_txt_output

% un-sort results so they fit to the input data
clear clusterID
clusterID(sortedOrder, :) = clusterID_sorted;

% reorder rows within kmeans output -> rebustness of cluster indices to random kmeans start
[clusterID, oldOrder]       = reNumerateClusters(clusterID);
centroids                   = centroids(oldOrder,:);
withinClusterDistance       = withinClusterDistance(oldOrder,:);

inputStructure.([prefix, 'kMeans_pointsClusterIndices'])     = clusterID;
inputStructure.([prefix, 'kMeans_centroids'])                = centroids;
inputStructure.([prefix, 'kMeans_withinClusterDistance'])    = withinClusterDistance;
