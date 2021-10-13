function CORE(CFG, thingIndices, MODE, jobInfo)

STAGE_NAME = 'STAGE_4';

isNoWorkToBeDone = isempty(thingIndices);
if(isNoWorkToBeDone)
    return
end

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas  = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);

loadData
checkLoadedDataNames

%%
kListLength = length(CFG.STAGE_4.kList);

clusteringEvaluationOneROI.optNumClustersAllIter    = nan(1, CFG.STAGE_4.nIterations);
clusteringEvaluationOneROI.criterionValues          = nan(1, CFG.STAGE_4.nIterations);

for iThing = thingIndices
    iROI = iThing;
    disp(['Processing ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ... '])

    % HERE STARTS THE ROI PROCESSING
    dataToTest = pooledClusters(iROI).centroidsAllSubjects;

    evaluateClustersNumber_Script
    
    % check results
    checkEvaluationSuccess(clusteringEvaluationOneROI)

    % choose most frequent and save as a separate field
    clusteringEvaluationOneROI.optimalNumClusters  = mode(clusteringEvaluationOneROI.optNumClustersAllIter);

    % save output
    cfg = [];
    cfg.variablePrefix  = 'optimalNumberOfClustersOneROI';
    cfg.thingPrefix     = 'iROI';
    cfg.thingIndex      = iROI;
    cfg.tmpFolder       = '../output/not_integrated/';
    saveCoreResult_1prefix(cfg, clusteringEvaluationOneROI);

    disp('Thing done.');

end % iThing
disp('CORE: ALL THINGS DONE !');
