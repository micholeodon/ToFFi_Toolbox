cfg = [];
cfg.dimord      = 'rpt_freq';
cfg.zThreshold  = CFG.(STAGE_NAME).trialRejectZ;
[singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials, rejectInfo]  = removeOutlierTrials(cfg, singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials);
singleSubjectSingleRoiData.rejectedTrialsIndices        = rejectInfo.rejectedTrialsIndices;
singleSubjectSingleRoiData.nTrialsBeforeRejection       = rejectInfo.nTrialsBeforeRejection;
singleSubjectSingleRoiData.nTrials                 = rejectInfo.nTrialsBeforeRejection - numel(rejectInfo.rejectedTrialsIndices);
