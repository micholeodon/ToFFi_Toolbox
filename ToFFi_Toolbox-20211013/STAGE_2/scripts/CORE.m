function CORE(CFG, normalizedSourcesPower, iSub, iROI, MODE, jobInfo)
% HERE STARTS THE ROI PROCESSING (for single subject, single ROI)
% input: 1 sub norm. pow. -> CORE -> output: single sub. single ROI ind. fingerprint

STAGE_NAME = 'STAGE_2';

iGoodSub = find(ismember(CFG.Global.goodSubjects, iSub));

% check loaded data
checkSourcesPower(normalizedSourcesPower)

%% Mean ROI Power
disp(['Processing ROI: ', num2str(iROI),  ' ... '])

initFields_Script
meanRoiPower_Script
rejectOutlierTrials_Script
% shift zero
if(CFG.STAGE_2.doZeroShift)
    singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials = shiftZero(singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials);
end

% save output no1 (if set in the parameters) - mean ROI power
if(CFG.STAGE_2.saveMeanRoiPower)
    SaveMeanRoiPower_Script
end

%% Individual Fingerprint

% set number of clusters (optimal or fixed)
switch CFG.STAGE_2.numClustersMode
    case 'optimal'
	OptimalClusters_Script

	numberOfClustersInThisRoi = mode(clusteringEvaluation.optNumClustersAllIter);

	optimalNumClustEvaluation = clusteringEvaluation;
	optimalNumClustEvaluation.numberOfClustersInThisRoi = numberOfClustersInThisRoi;
	singleSubjectSingleRoiData.optimalNumClustEvaluation = optimalNumClustEvaluation;

    case 'fixed'
	numberOfClustersInThisRoi = CFG.STAGE_2.nSpectralModesPerROI;
    otherwise
	error('STAGE_2 : ERROR ! Unrecognized numClustersMode config parameter value !');
end % switch

ClusteringIF_Script

% save output no2 - IFs
SaveIF_Script

disp('CORE: ROI DONE !');
