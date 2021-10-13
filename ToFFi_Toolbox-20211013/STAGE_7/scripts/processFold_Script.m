disp(['fold = ', num2str(iFold)])

trPts = find(CV_singleRep(iRep).cvPart.training(iFold)');
vaPts = find(CV_singleRep(iRep).cvPart.test(iFold)');
nPtsTr = numel(trPts); % careful with indexing!
nPtsVa = numel(vaPts); % careful with indexing!

nLogLMatrix = nan(nGoodROI, nGoodROI); % careful with indexing!

Training_Script

Testing_Script

Measures_Script

NLL_singleRep.Folds(iFold).nLogL = nLogLMatrix;
