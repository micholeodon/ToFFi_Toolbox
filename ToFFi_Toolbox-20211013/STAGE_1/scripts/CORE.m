function CORE(CFG, iSub, nSub)

STAGE_NAME='STAGE_1'

iGoodSub = find(ismember(CFG.Global.goodSubjects, iSub));

disp(['Processing subject: ', num2str(iGoodSub), ' / ', num2str(nSub), ' = Sub_', num2str(iSub), ' ... '])
subjectDir = [CFG.STAGE_1.outputDataFolder,'Sub_', num2str(iSub), '/'];

run loadSingleSubjectData
run checkLoadedDataNames
checkDataAndFilter(data, spatialFilter)

cfg = [];
cfg.name = 'data.trial';
checkTrials_Warn_NaN_or_Infinities(cfg, data.trial);

SourcesTimeSeries_Script
disp('Checkpoint 1 !')

SourcesPower_Script
disp('Checkpoint 2 !')

SourcesNormalization_Script
disp('Checkpoint 3 !')

disp('Saving data ...')
save([subjectDir, 'normalizedSourcePower_', num2str(iSub)], 'normalizedSourcesPower')

disp('Checkpoint 4 !')
disp(['Subject ', num2str(iSub), ' : DONE !']);
