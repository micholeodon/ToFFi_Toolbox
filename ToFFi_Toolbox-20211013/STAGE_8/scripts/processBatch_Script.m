roisInThisBatch = batchesIndicesSets{iBatch};
nWorkers = numel(roisInThisBatch);
spmd(nWorkers)

    workerID = labindex;

    % RNG_2.2 Set worker rng stream
    [spmdTestVec, ~] = ...
	setRngSpmdSeed(batchSeeds(iBatch), workerID, nWorkers);

    % display rng state
    tmp = rng;
    disp(['workerID=', num2str(labindex), ...
	  ';rng.Seed=', num2str(tmp.Seed), ...
	  ';rand=', num2str(rand)])


    SPMD_jGoodROI = roisInThisBatch(labindex);
    SPMD_jROI     = goodROI(SPMD_jGoodROI);

    SPMD_singleRoiFingerprintFile = [CFG.(STAGE_NAME).inputDataFolder{SF_FOLDER_IDX}, CFG.STAGE_8.spectralFingerprintsFileNamePrefix, num2str(SPMD_jROI), '.mat'];
    SPMD_data = load(SPMD_singleRoiFingerprintFile);

    SPMD_data.singleRoiSpectralFingerprint = discardNonMajorityModes(SPMD_data.singleRoiSpectralFingerprint, CFG.STAGE_8.majoritySubjectsNum);

    % copy certain fields
    SPMD_data.majSF.iROI = SPMD_data.singleRoiSpectralFingerprint.iROI;
    SPMD_data.majSF.nRoiAtlas = SPMD_data.singleRoiSpectralFingerprint.nRoiAtlas;
    SPMD_data.majSF.goodROI = SPMD_data.singleRoiSpectralFingerprint.goodROI;
    SPMD_data.majSF.freqAxis = SPMD_data.singleRoiSpectralFingerprint.freqAxis;
    SPMD_data.majSF.lvl2_gmm_centroids = SPMD_data.singleRoiSpectralFingerprint.Maj_lvl2_gmm_centroids;
    SPMD_data.majSF.lvl2_gmm_gmClassInstance = SPMD_data.singleRoiSpectralFingerprint.Maj_lvl2_gmm_gmClassInstance;
    SPMD_data.majSF.lvl2_gmm_centroidDuration = SPMD_data.singleRoiSpectralFingerprint.Maj_lvl2_gmm_centroidDuration;
    SPMD_data.majSF.lvl2_gmm_subjectsContributed = SPMD_data.singleRoiSpectralFingerprint.Maj_lvl2_gmm_subjectsContributed;
    SPMD_data.majSF.lvl2_gmm_nSubjectsPerCentroid = SPMD_data.singleRoiSpectralFingerprint.Maj_lvl2_gmm_nSubjectsPerCentroid;

    nMajModes = size(SPMD_data.majSF.lvl2_gmm_centroids,1);
    if( nMajModes == 0 )
	SPMD_fitMatrixSingleRow = nan(1, nRoiAtlas);
    else
	SPMD_fitMatrixSingleRow = calculateFit(cfg, ...
					       singleRoiPooledPoints, SPMD_data.majSF);
    end

    SPMD_fitMatrixSingleRow = calculateFit(cfg, singleRoiPooledPoints, SPMD_data.majSF);
end % spmd

% Integrate results from workers
for iWorker = 1:nWorkers
    jGoodROI = roisInThisBatch(iWorker);
    jROI  = goodROI(jGoodROI);
    fitMatrix(iROI, jROI) = SPMD_fitMatrixSingleRow{iWorker};
end

% RNG_2.3 Save rng of each batch
saveRngSpmdInfo('../output/rngSpmd', jobInfo.jobID, iBatch, spmdTestVec)
clear spmdTestVec spmdStream

% clear variable to reset spmd
clear SPMD_jGoodROI SPMD_jROI SPMD_fitMatrixSingleRow  SPMD_singleRoiFingerprintFile SPMD_data workerID tmp
