% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../output/CFG.mat')  % stage config contains global config parameters
addpath ../functions
addGlobalFunctions(CFG.Global)
setupFieldtrip(CFG.Global)

notIntegratedFolder = '../output/not_integrated/';

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
roiLabels   = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
nRoiAtlas   = length(roiLabels);
nGoodRoi    = length(CFG.Global.goodROI);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% INTEGRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errorDuringIntegrationException = [];
try

    % init field of output structure
    clusteringEvaluationAllROI(nRoiAtlas).optimalNumClusters        = nan(1,1);
    clusteringEvaluationAllROI(nRoiAtlas).optNumClustersAllIter     = nan(1, CFG.STAGE_4.nIterations);
    clusteringEvaluationAllROI(nRoiAtlas).criterionValues           = nan(1, CFG.STAGE_4.nIterations);
    clusteringEvaluationAllROI(nRoiAtlas).iROI                      = 0;
    clusteringEvaluationAllROI(nRoiAtlas).goodRoi                   = CFG.Global.goodROI;

    for iGoodROI = 1:nGoodRoi
	iROI = CFG.Global.goodROI(iGoodROI);
	disp([  'Integrating ROI: ', num2str(iROI), ' / ', num2str(nGoodRoi), ' ...']);

	partFile = [notIntegratedFolder, 'optimalNumberOfClustersOneROI_iROI', num2str(iROI)];
	load(partFile)

	% append fields from part to output structure
	clusteringEvaluationAllROI(iROI).optimalNumClusters         = clusteringEvaluationOneROI.optimalNumClusters;
	clusteringEvaluationAllROI(iROI).optNumClustersAllIter      = clusteringEvaluationOneROI.optNumClustersAllIter;
	clusteringEvaluationAllROI(iROI).criterionValues            = clusteringEvaluationOneROI.criterionValues;
	clusteringEvaluationAllROI(iROI).iROI                       = iROI;
	clusteringEvaluationAllROI(iROI).goodRoi                    = CFG.Global.goodROI;


    end % nGoodRoi loop

    disp(['Saving data ...']);
    fileName = [CFG.STAGE_4.outputDataFolder, 'clusteringEvaluationAllROI.mat'];
    save(fileName, 'clusteringEvaluationAllROI', '-v7.3')

    if(~exist(fileName, 'file'))
	error('File somehow not saved !')
    end


catch errorDuringIntegrationException
    warning('Something wrong happened during integration ! not-integrated files will not be clead for safety !');
    fprintf(1,'The identifier was:\n%s',errorDuringIntegrationException.identifier);
    fprintf(1,'There was an error! The message was:\n%s',errorDuringIntegrationException.message);
    disp('Integration finished with errors.');

end % try

if isempty(errorDuringIntegrationException)
    cleanNotIntegratedFolder(notIntegratedFolder);
    disp('Integration DONE !');
end
