% Testing_Script.m (calculate fit)
% ########################################################
for jGoodROI = 1:nGoodROI
    jROI = goodROI(jGoodROI);
    roiModel = trainingModel(jROI).gmm_gmClassInstance;
    dropIdx = find(trainingModel(jROI).nonPopularModeFlags);

    roiModelMajority = dropNonPopularClusters(roiModel, dropIdx);

    if(roiModelMajority.NumComponents == 0)
	nLogLMatrix(:, jGoodROI, :) = inf;
	warning(['WARNING! ROI model no ', num2str(jROI), ' has no clusters represented by the majority of subjects! Whole column of the NLogLMatrix will be set to INF!']);

    else
	for iGoodROI = 1:nGoodROI
	    iROI = goodROI(iGoodROI);

	    disp(['Testing ROI=', num2str(iROI), ' centroids (each subject separately) ...'])

	    cfg = [];
	    cfg.selectedSubjectIndices = vaSub;
	    evalc(['[centroidsFromVaSub, ', '~, ', ...
		   'centroidsVaSubIndices] = get_selectedSubjectsCentroids(cfg, pooledClusters(iROI))']);

	    for s = 1:nSubVa
		iSub = vaSub(s);
		centroids = centroidsFromVaSub(centroidsVaSubIndices == iSub, :);
		nlogl = fitTestRoiPointsToRoi([], centroids, roiModelMajority);

		nLogLMatrix(iGoodROI, jGoodROI, s) = nlogl; % careful with indexing
	    end % s

	end % iGoodROI
    end % if
end % jGoodROI

disp('Testing done !')

% ########################################################
