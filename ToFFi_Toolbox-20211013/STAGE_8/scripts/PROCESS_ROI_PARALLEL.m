[batchesIndicesSets, nBatches]  = prepareBatchesIndices(CFG.Global.maxNumSpmdWorkers, nGoodROI);

for iGoodROI = 1:nGoodROI
    iROI     = goodROI(iGoodROI);
    disp(['Processing ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ... '])

    cfg = [];
    cfg.selectedSubjectIndices = CFG.Global.goodSubjects;
    [singleRoiPooledPoints, ~] = get_selectedSubjectsCentroids(cfg, pooledClusters(iROI));

    % RNG_2.1 Generate unique seed for each batch
    batchSeeds = generateSeeds(nBatches);

    for iBatch = 1:nBatches
        processBatch_Script
    end % iBatch

end % iGoodROI
