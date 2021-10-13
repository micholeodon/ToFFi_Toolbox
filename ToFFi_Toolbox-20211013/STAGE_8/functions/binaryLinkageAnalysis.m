function binaryLinkage = binaryLinkageAnalysis(cfg, stageConfig, fitMatrix)
%%
% Performs hierarchical agglomerative hierarchical clustering on the input
% data matrix.
%
% References:
% [1] "Similarity across Areas" section in A. Keitel and J. Gross,
% “Individual human brain areas can be identified from their characteristic
% spectral activation fingerprints,” PLoS Biol, vol. 14, no. 6, p. e1002498,
% 2016.
%
% [2] MATLAB Documentation about linkage function:
% https://www.mathworks.com/help/stats/linkage.html
%% Inputs
% *cfg* - struct with fields:
%
% _goodRows_ - double; 1D-array with positive integers meaning rows to be
%              selected from *fitMatrix* to perform the linkage.
%
% _goodCols_ - double; 1D-array with positive integers meaning colums to be
%              selected from *fitMatrix* to perform the linkage.
%
% _observationsLabels_ - (optional) cell array with names describing each of
%                        the observation to be clustered.
%
% *stageConfig* - struct representing STAGE_8 configuration. Used fields:
%
% _linkageMethod_ - char; name of the method to be used. Possible values:
% https://www.mathworks.com/help/stats/linkage.html#mw_59e9693d-3784-4a0d-89dd-5dd020a605b2
%
% _linkageDistanceMetric_ - char; name of the metric to be used to compare
%                           observations stored in the *fitMatrix* input
%                           argument. Possible values:
% https://www.mathworks.com/help/stats/linkage.html#d122e490032
%
% _nSimilarityClusters_ - double; integer number of clusters to be
%                         found. Hierarchical binary-linkage tree will be
%                         pruned at that level.
%
% *fitMatrix* - double 2D-array containing data to be clustered.
%               Size: N x D, where N is the number of observations to be
%               clustered and D is the number of dimensions /
%               variables. In the context of Spectral Fingerprinting it is
%               called "fitMatrix" because it contains ROI-to-ROI fitness
%               values. See: "Similarity across Areas" section in A. Keitel
%               and J. Gross, “Individual human brain areas can be identified
%               from their characteristic spectral activation fingerprints,”
%               PLoS Biol, vol. 14, no. 6, p. e1002498, 2016.
%% Outputs
% *binaryLinkage* - struct with fields:
%
% _Linkage_ - output of the MATLAB function linkage. Details:
% https://www.mathworks.com/help/stats/linkage.html#mw_8be7e070-3def-4f14-8875-d74a0e9b5f94
%
% _hierarchicalClusterTreeLeafs_ - double 2D-array that contain cluster
%                                  indices linked in pairs to form a binary tree.
%
% _TreeFull.leafNodesIndices_ - double 1D-array with leaf node numbers for
%                               each data point in the original data set
%                               (refers to full binary tree). See:
% https://www.mathworks.com/help/stats/dendrogram.html#d122e231482
%
% _TreeTruncated.leafNodesIndices_ - double 1D-array with leaf node numbers for
%                                    each data point in the original data set
%                                    (refers to full binary tree truncated at
%                                    level *cfg.nSimilarityClusters*). to
%                                    find out which data points are contained
%                                    in leaf node k of the dendrogram plot,
%                                    use find(T==k). See:
% https://www.mathworks.com/help/stats/dendrogram.html#d122e231482
%
% _nSimilarityClusters_ - same as input *stageConfig.nSimilarityClusters*.
%
% _simClusterInfo.indices_ - (optional) cell array with double 1D-arrays (one
%                            cell per cluster) containing indices of
%                            observations that fell into given
%                            cluster. Present only if
%                            *cfg.observationsLabels* field exist.
%
% _simClusterInfo.label_ - (optional) cell array with chars (one cell per
%                          cluster) containing names of observations that
%                          fell into given cluster. Present only if
%                            *cfg.observationsLabels* field exist.
%%

if(~isfield(cfg, 'goodRows')) error('Missing goodRows field in cfg argument !'); end
if(~isfield(cfg, 'goodCols')) error('Missing goodCols field in cfg argument !'); end

fitMatrixGood = fitMatrix(cfg.goodRows, cfg.goodCols);

% handle NaN values before linkage
fitMatrixGood(isnan(fitMatrixGood))=100*max(max(fitMatrixGood));

Z = linkage(fitMatrixGood, ...
    stageConfig.linkageMethod, ...
    stageConfig.linkageDistanceMetric);

figure('visible', 'off') % to catch figure of tree from dendrogram (prevent display)
[~, T_trunc]    = dendrogram(Z, stageConfig.nSimilarityClusters); close;
figure('visible', 'off') % to catch figure of tree from dendrogram (prevent display)
[~, T_full]     = dendrogram(Z, 0); close;

binaryLinkage.Linkage                          = Z; % full linkage
binaryLinkage.hierarchicalClusterTreeLeafs     = Z(:, 1:2); % description of numbers here : https://www.mathworks.com/help/stats/linkage.html#d120e466848
binaryLinkage.TreeFull.leafNodesIndices        = T_full;
binaryLinkage.TreeTruncated.leafNodesIndices   = T_trunc;
binaryLinkage.nSimilarityClusters              = stageConfig.nSimilarityClusters;


% add info about linked ROIs for easier interpretation
if(isfield(cfg, 'observationsLabels'))

    binaryLinkage.simClusterInfo = [];
    for iSimCluster = 1:binaryLinkage.nSimilarityClusters
	binaryLinkage.simClusterInfo.indices{iSimCluster} = cfg.goodRows(find(binaryLinkage.TreeTruncated.leafNodesIndices == iSimCluster));
	binaryLinkage.simClusterInfo.label{iSimCluster}   = {cfg.observationsLabels{binaryLinkage.simClusterInfo.indices{iSimCluster}}}';
    end

end
