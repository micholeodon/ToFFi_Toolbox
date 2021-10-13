% Measures_Script.m (calculate accuracy and ranks)
% ########################################################
disp('Calculating accuracy and ranks ...')
acc         = zeros(1, nGoodROI);
mr          = zeros(1, nGoodROI);
acc_std     = zeros(1, nGoodROI);
mr_std      = zeros(1, nGoodROI);
for iGoodROI = 1:nGoodROI
    L = nLogLMatrix(iGoodROI,:);
    R = tiedrank(L);
    r = R(iGoodROI);
    a = (r == 1); % is iROI recognized as iROI (the most probable?)

    acc(iGoodROI)   = a;
    mr(iGoodROI)    = r;
end % iROI

CV_singleRep(iRep).cvFold(iFold).iFold = iFold;
CV_singleRep(iRep).cvFold(iFold).trPts = trPts;
CV_singleRep(iRep).cvFold(iFold).vaPts = vaPts;
CV_singleRep(iRep).cvFold(iFold).rslts.acc_atlasROI(goodROI)    = acc;
CV_singleRep(iRep).cvFold(iFold).rslts.mr_atlasROI(goodROI)     = mr;
acc_folds(iFold,:)   = acc;
mr_folds(iFold,:)    = mr;

disp('Calculating accuracy and ranks DONE!')
% ########################################################
