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
    data.iSub = iSub;
    data.jobInfo = jobInfo;

    % select points for training & from iROI
    idx1 = trPts;
    idx2 = find(groups == iROI);
    idx = intersect(idx1, idx2);
    data.points = points(idx, :);

    % training
    roiModel = Gen_TrModel_S7(CFG, MODE, data);
    trainingModel(iROI) = roiModel;

end % iGoodROI

% to make struct cover all ROI in atlas (and prevent errors
% in other scripts)
trainingModel(nRoiAtlas).iROI = [];

disp('Training done !')
% ########################################################