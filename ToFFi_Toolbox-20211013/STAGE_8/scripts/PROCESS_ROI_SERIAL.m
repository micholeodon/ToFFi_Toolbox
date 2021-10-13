for iGoodROI = 1:nGoodROI
    iROI     = goodROI(iGoodROI);
    disp(['Processing ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ... '])

    cfg = [];
    cfg.selectedSubjectIndices = CFG.Global.goodSubjects;
    [singleRoiPooledPoints, ~] = get_selectedSubjectsCentroids(cfg, pooledClusters(iROI));

    for jGoodROI = 1:nGoodROI
        jROI = goodROI(jGoodROI);
        singleRoiFingerprintFile = [CFG.(STAGE_NAME).inputDataFolder{SF_FOLDER_IDX}, CFG.STAGE_8.spectralFingerprintsFileNamePrefix, num2str(jROI), '.mat'];
        load(singleRoiFingerprintFile)

        singleRoiSpectralFingerprint = discardNonMajorityModes(singleRoiSpectralFingerprint, CFG.STAGE_8.majoritySubjectsNum);
        % copy certain fields
        majSF.iROI = singleRoiSpectralFingerprint.iROI;
        majSF.nRoiAtlas = singleRoiSpectralFingerprint.nRoiAtlas;
        majSF.goodROI = singleRoiSpectralFingerprint.goodROI;
        majSF.freqAxis = singleRoiSpectralFingerprint.freqAxis;
        majSF.lvl2_gmm_centroids = singleRoiSpectralFingerprint.Maj_lvl2_gmm_centroids;
        majSF.lvl2_gmm_gmClassInstance = singleRoiSpectralFingerprint.Maj_lvl2_gmm_gmClassInstance;
        majSF.lvl2_gmm_centroidDuration = singleRoiSpectralFingerprint.Maj_lvl2_gmm_centroidDuration;
        majSF.lvl2_gmm_subjectsContributed = singleRoiSpectralFingerprint.Maj_lvl2_gmm_subjectsContributed;
        majSF.lvl2_gmm_nSubjectsPerCentroid = singleRoiSpectralFingerprint.Maj_lvl2_gmm_nSubjectsPerCentroid;

        clear singleRoiSpectralFingerprint

        nMajModes = size(majSF.lvl2_gmm_centroids,1);
        if( nMajModes == 0 )
            fitMatrix(iROI, jROI) = nan;
        else
            fitMatrix(iROI, jROI) = calculateFit(cfg, ...
                                                 singleRoiPooledPoints, majSF);
        end

    end % jGoodROI
end % iGoodROI
