% Measures_Script.m (calculate accuracy and ranks)
% ########################################################
disp('Calculating accuracy and ranks ...')
acc         = zeros(1, nGoodROI);
mr          = zeros(1, nGoodROI);
acc_std     = zeros(1, nGoodROI);
mr_std      = zeros(1, nGoodROI);
for iGoodROI = 1:nGoodROI
    a = zeros(1, nSubVa);
    r = zeros(1, nSubVa);
    for s = 1:nSubVa
	L = nLogLMatrix(iGoodROI,:,s);
	R = tiedrank(L);
	r(s) = R(iGoodROI);
	a(s) = (R(iGoodROI) == 1); % "is iROI recognized as iROI (the most probable?)"
    end
    acc(iGoodROI)   = mean(a);
    mr(iGoodROI)    = mean(r);
    acc_std(iGoodROI)   = std(a);
    mr_std(iGoodROI)    = std(r);

end % iROI

CV_singleRep.cvFold(iFold).iFold = iFold;
CV_singleRep.cvFold(iFold).trSub = trSub;
CV_singleRep.cvFold(iFold).vaSub = vaSub;

CV_singleRep.cvFold(iFold).rslts.acc_atlasROI    = zeros(1, nRoiAtlas);
CV_singleRep.cvFold(iFold).rslts.acc_atlasROI(goodROI)    = acc;

CV_singleRep.cvFold(iFold).rslts.mr_atlasROI     = zeros(1, nRoiAtlas);
CV_singleRep.cvFold(iFold).rslts.mr_atlasROI(goodROI)     = mr;

CV_singleRep.cvFold(iFold).rslts.acc_std_atlasROI    = zeros(1, nRoiAtlas);
CV_singleRep.cvFold(iFold).rslts.acc_std_atlasROI(goodROI)    = acc_std;

CV_singleRep.cvFold(iFold).rslts.mr_std_atlasROI     = zeros(1, nRoiAtlas);
CV_singleRep.cvFold(iFold).rslts.mr_std_atlasROI(goodROI)     = mr_std;

acc_folds(iFold,:)   = acc;
mr_folds(iFold,:)    = mr;

disp('Calculating accuracy and ranks DONE!')
% ########################################################
