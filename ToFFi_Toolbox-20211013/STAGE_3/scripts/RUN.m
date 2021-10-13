STAGE_NAME = 'STAGE_3'

tic

Init_Script

[list_data, isMissingData] = checkStageDataPresence(CFG.(STAGE_NAME), ...
    CFG.Global.goodSubjects);
nGoodSub        = length(CFG.Global.goodSubjects);
nGoodRoi    = length(CFG.Global.goodROI);
% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
roiLabels   = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
nRoiAtlas   = length(roiLabels);

eachSubjectClusters = cell(1, nGoodSub); % init this structure (intermediate step - flexible for uneven number of modes)
pooledClusters(nRoiAtlas).numCentroidsPerSubject    = [];
pooledClusters(nRoiAtlas).centroidsAllSubjects      = [];
pooledClusters(nRoiAtlas).centroidsSubjectIndices   = [];
pooledClusters(nRoiAtlas).centroidsDuration         = [];
pooledClusters(nRoiAtlas).iROI                      = [];
pooledClusters(nRoiAtlas).nRoiAtlas                 = [];
pooledClusters(nRoiAtlas).goodROI                   = [];

for iGoodSub = 1:nGoodSub
    iSub = CFG.Global.goodSubjects(iGoodSub);

    disp(['Processing subject: ', num2str(iGoodSub), ' / ', num2str(nGoodSub), ' ... '])
    subjectDir = [CFG.(STAGE_NAME).outputDataFolder,'Sub_', num2str(iSub), '/'];

    loadSingleSubjectData
    checkLoadedDataNames

    eachSubjectClusters{iGoodSub} = individualFingerprint;
end


for iGoodROI = 1:nGoodRoi
    iROI = CFG.Global.goodROI(iGoodROI);
    disp(['Processing ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ... '])

    for iGoodSub = 1:nGoodSub
	cfg              = [];
	cfg.iROI         = iROI;
	cfg.goodROI      = CFG.Global.goodROI;
	pooledClusters(iROI) = appendSubjectDependentData(cfg, pooledClusters(iROI), eachSubjectClusters{iGoodSub});
    end

    pooledClusters(iROI).iROI       = iROI;
    pooledClusters(iROI).nRoiAtlas  = nRoiAtlas;
    pooledClusters(iROI).goodROI    = CFG.Global.goodROI;
    pooledClusters(iROI).freqAxis   = eachSubjectClusters{1}.freqAxis; % each sub has same freq. axis.

end

% save pooled points
save([CFG.(STAGE_NAME).outputDataFolder, 'pooledClustersInAllROI'], 'pooledClusters', '-v7.3')

time = toc;
save('../output/time.mat', 'time');
