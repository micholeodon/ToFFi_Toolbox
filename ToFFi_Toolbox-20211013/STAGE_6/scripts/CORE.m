function CORE(CFG, iRep, stageData, MODE)

STAGE_NAME = 'STAGE_6';

% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas       = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
goodROI         = CFG.Global.goodROI;
nGoodROI        = length(goodROI);
goodSub         = CFG.Global.goodSubjects;
nGoodSub        = length(goodSub);
nReps           = CFG.(STAGE_NAME).CV.nRepetitions;
nFolds          = CFG.(STAGE_NAME).CV.nFolds;

pooledClusters = stageData.pooledClusters;
nClustersPerRoi = stageData.nClustersPerRoi;

CV_singleRep.iRep = iRep;

% generate folds
CV_singleRep.cvPart = cvpartition(nGoodSub, 'KFold', nFolds);

% classify in each fold
acc_folds   = zeros(nFolds, nGoodROI);
mr_folds    = zeros(nFolds, nGoodROI);
for iFold = 1:nFolds
    processFold_Script
    save(['../output/roiModels_Rep_', num2str(iRep), '_Fold_', num2str(iFold), '.mat'], 'trainingModel')
end

% calculate mean across folds
CV_singleRep.accRoiMeanFolds = zeros(1, nRoiAtlas);
CV_singleRep.accRoiMeanFolds(goodROI)           = mean(acc_folds, 1);

CV_singleRep.acc_std_RoiStdFolds = zeros(1, nRoiAtlas);
CV_singleRep.acc_std_RoiStdFolds(goodROI)      = std(acc_folds, 0, 1);

CV_singleRep.meanRankRoiMeanFolds = zeros(1, nRoiAtlas);
CV_singleRep.meanRankRoiMeanFolds(goodROI)      = mean(mr_folds, 1);

CV_singleRep.meanRank_std_RoiStdFolds = zeros(1, nRoiAtlas);
CV_singleRep.meanRank_std_RoiStdFolds(goodROI) = std(mr_folds, 0, 1);

% save repetition (to be integrated in INTEGRATE.m script)
Save_Script

disp('Thing done.');
