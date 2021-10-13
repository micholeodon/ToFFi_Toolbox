function singleSubjectSingleRoiData = clusterPower_Kmeans(cfg, singleSubjectSingleRoiData)
%%
% Performs K-means clustering on the multidimensional data. Uses standard
% MATLAB kmeans routine with additional improvements:
%
% - initial sorting (result is invariant to the order of rows of the data matrix)
%
% - post-relabeling (for given solution labels are always the same,
%   see reNumerateClusters.m for further explanation).
%% Inputs
% *cfg* - struct; configuration with fields:
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
% *singleSubjectSingleRoiData* - struct; Contains data to be clustered for
%                                the single subject. Obligatory fields:
%
% _normalizedPowerSpectrum_Trials_ - double; 2D-array that contains values of
%                                    normalized power spectrum for each time
%                                    segment and frequency. Each row
%                                    represent single point.
%                                    Size: trials x frequencies.
%% Outputs
% *singleSubjectSingleRoiData* - struct; Contains clustered data for
%                                the single subject. Same as in input but
%                                extended with new fields:
%
% _trialsClusterIndices_ - double; 1D-array containing cluster index for each
%                          of the clustered points in the input data matrix.
%                          Contain values from 1 to cfg.nClusters.
%
% _roiCentroids_ - double; 2D-array of size cfg.nClusters x frequencies. Each
%                  row contains single cluster center (centroid).
%
% _roiWithinClusterDistance_ - double; 1D-array of within-cluster sums of
%                              point-to-centroid distances.
%%

display('K-means clustering ...')

if(~isfield(cfg, 'distanceMetric')) error('Missing field distanceMetric in cfg input argument !'); end
if(~isfield(cfg, 'nReplicates'))    error('Missing field nReplicates in cfg input argument !');  end
if(~isfield(cfg, 'nClusters'))    error('Missing field nClusters in cfg input argument !');  end


singleSubjectSingleRoiData.trialsClusterIndices       = [];
singleSubjectSingleRoiData.roiCentroids               = [];
singleSubjectSingleRoiData.roiWithinClusterDistance   = [];

displayOption   = statset('Display','final');
trialsToCluster = singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials;

[trialsToCluster_sorted, sortedOrder] = sortrows(trialsToCluster);
waste_txt_output = evalc(['[trialClusterID_sorted, centroids, withinClusterDistance] = kmeans( trialsToCluster_sorted, cfg.nClusters,' ...
    ' ''Options'', displayOption,' ...
    ' ''Distance'', cfg.distanceMetric,' ...
    ' ''Replicates'', cfg.nReplicates);']);
clear waste_txt_output
% unsort
clear trialClusterID
trialClusterID(sortedOrder, :) = trialClusterID_sorted;

% reorder rows within kmeans output -> robustness of cluster indices to random kmeans start
[trialClusterID, oldOrder]  = reNumerateClusters(trialClusterID);
centroids                   = centroids(oldOrder,:); % we need to reorder centroids too to match new IDs
withinClusterDistance       = withinClusterDistance(oldOrder,:); % ditto

singleSubjectSingleRoiData.trialsClusterIndices     = trialClusterID;
singleSubjectSingleRoiData.roiCentroids             = centroids;
singleSubjectSingleRoiData.roiWithinClusterDistance = withinClusterDistance;
