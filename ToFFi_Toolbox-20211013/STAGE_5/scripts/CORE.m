function CORE(CFG, roiIndices, jobInfo)

STAGE_NAME = 'STAGE_5';

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas  = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);

loadData_Stage5
checkLoadedDataNames

for iROI = roiIndices
    disp(['Processing ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ... '])

    % extract single ROI data with meaningful field names
    singleRoiData = pooledClusters(iROI);
    % copy fields with different names
    initFields_Script

    clusteringSF_Script

    nClusters = size(singleRoiData.lvl2_gmm_centroids, 1);
    % compute cluster: FINISH
    % - duration
    % - subject contribution ("are lvl2 centroids popular? (majority of subjects contribute to them)")
    for iCluster = 1:nClusters
        computeClusterExtraFeatures_Script
    end

    % Adding some informations
    singleRoiData.isOnlyPopularClustersShown = 0;
    % that means that in order to show real spectral fingerprint
    % you need to show only those clusters
    % whos subjectCountForCluster is >= CFG.majoritySubjectsNum

    % change name
    singleRoiSpectralFingerprint = singleRoiData;
    clear singleRoiData

    % save output
    saveRoiSF_Script

    disp(['ROI ', num2str(iROI), ' done.']);

end % roiIndices
disp('CORE: ALL ROI DONE !');
