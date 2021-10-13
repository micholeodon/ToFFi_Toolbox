function nClustersPerROI = set_nClustersPerRoiForTraining(CFG, stageName)
%%
% According to the configuration for stage named *stageName* (stored in *CFG*
% argument) it sets entries of the nClustersPerROI cell array.
%% Inputs
% *CFG* - struct with global configuration and configuration for stage named
%         as in *stageName* argument. This stage configuration should have
%         following fields: _nClustersSetting_, _fixed_nClusters_,
%         _optimalClustersDataFile_. 
%% Outputs
% *nclustersPerROI* - 1D cell array (size: 1 x number of ROI in atlas)
%                     containing in each cell number of clusters to be
%                     computed single ROI. Depending on the value of
%                     CFG.(stageName).nClustersSetting:
%
% 'fixed' - *nClustersPerROI* will contain same number in each cell
%
% 'optimal' - *nClustersPerROI* will contain optimal number in each cell. Number
%             of clusters for each ROI is the same as it was calculated in
%             STAGE_4.
%
% 'mode' - *nClustersPerROI* will contain number of clusters equal to the
%          most frequent number of clusters across training subjects (for
%          each ROI separately).
%%

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas  = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
clustersNumberSetting = CFG.(stageName).nClustersSetting;
switch clustersNumberSetting
    case 'fixed'
	nClustersPerROI = cell(1, nRoiAtlas);
	for iGoodROI = CFG.Global.goodROI
	    nClustersPerROI{iGoodROI} = CFG.(stageName).fixed_nClusters;
	end
    case 'optimal' % follow optimal number calculated in STAGE_4 and used in
		   % STAGE_5
	optClustFilename = CFG.(stageName).optimalClustersDataFile;
	if(~exist(optClustFilename))
	    error(['File ', optClustFilename, ' not exist !']);
	end
	load(optClustFilename);
	nClustersPerROI = {clusteringEvaluationAllROI.optimalNumClusters};

    case 'mode'
	% default; for each training set number of clusters will be equal to
	% the most frequent across training subjects
	nClustersPerROI = cell(1, nRoiAtlas);

end
