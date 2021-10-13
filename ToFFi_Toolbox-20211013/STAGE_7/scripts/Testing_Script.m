% Testing_Script.m (calculate fit)
% ########################################################
for jGoodROI = 1:nGoodROI
    jROI = goodROI(jGoodROI);
    roiModel = trainingModel(jROI).gmm_gmClassInstance;

    for iGoodROI = 1:nGoodROI
	iROI = goodROI(iGoodROI);

	disp(['Testing ROI=', num2str(iROI), ' centroids ... (SUB=', num2str(iSub), ')'])

	% select validation points & from iROI
	idx1 = vaPts;
	idx2 = find(groups == iROI);
	idx = intersect(idx1, idx2);
	vaPoints = points(idx, :);

	nlogl = fitTestRoiPointsToRoi([], vaPoints, roiModel);
	nLogLMatrix(iGoodROI, jGoodROI) = nlogl; % careful with indexing

    end % iGoodROI

end % jGoodROI

disp('Testing done !')

% ########################################################
