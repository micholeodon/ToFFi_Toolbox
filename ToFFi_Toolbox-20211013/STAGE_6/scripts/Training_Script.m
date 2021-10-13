% Training_Script (calculate models)
% ########################################################
% init structure
for iGoodROI = 1:nGoodROI
    iROI = goodROI(iGoodROI);

    disp(['Training ROI=', num2str(iROI), ' model ...'])

    data = [];
    data.STAGE_NAME = STAGE_NAME;
    data.iRep = iRep;
    data.iFold = iFold;
    data.iROI = iROI;
    data.trSub = trSub;
    data.pooledClusters = pooledClusters;
    data.nClustersPerRoi = nClustersPerRoi;
    roiModel = Gen_TrModel(CFG, MODE, data);
    trainingModel(iROI) = roiModel;

end % iGoodROI

% to make struct cover all ROI in atlas (and prevent errors
% in other scripts)
trainingModel(nRoiAtlas).iROI = [];

disp('Training done !')
% ########################################################