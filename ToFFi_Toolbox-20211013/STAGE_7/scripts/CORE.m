function CORE(CFG, iSub, MODE, jobInfo)

% For each individual subject iSub subset of his single time segment ROI
% spectra are used to train individual GMM models and rest of
% single time segments are used to validate the models.

STAGE_NAME = 'STAGE_7';


% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
nRoiAtlas       = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
goodROI         = CFG.Global.goodROI;
nGoodROI        = length(goodROI);
goodSub         = CFG.Global.goodSubjects;
nGoodSub        = length(goodSub);
nReps           = CFG.(STAGE_NAME).CV.nRepetitions;
nFolds          = CFG.(STAGE_NAME).CV.nFolds;

% load individual data into single matrix
loadSingleSubjectData_STAGE_7

% CV
acc_reps = zeros(nReps, nRoiAtlas);
mr_reps  = zeros(nReps, nRoiAtlas);

for iRep = 1:nReps
    disp(['iRep = ', num2str(iRep)])
    CV_singleRep(iRep).iRep = iRep;

    % generate folds
    CV_singleRep(iRep).cvPart = cvpartition(groups, 'KFold', nFolds);

    % classify in each fold
    acc_folds   = zeros(nFolds, nGoodROI);
    mr_folds    = zeros(nFolds, nGoodROI);
    for iFold = 1:nFolds
        processFold_Script
    end % iFold

    % calculate mean across folds
    meansAndStd_1_Script

    % cumulate to average later
    acc_reps(iRep,:) = CV_singleRep(iRep).accRoiMeanFolds;
    mr_reps(iRep,:)  = CV_singleRep(iRep).meanRankRoiMeanFolds;

    % save indicator file for finished repetition
    indicatorSave_Script
end % iRep

meansAndStd_2_Script
indCV.CV_singleRep = CV_singleRep;

% Save
Save_Script

disp('Subject done.');
