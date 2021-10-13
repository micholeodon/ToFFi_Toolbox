clear; close all; clc;

%% preparation
stageConfig.dataNamesList   = {'dataA', 'dataB'};
goodSubjectsIndices         = [1 2 3];

%% %% Loading data from individual subjects from ONE input folder

stageConfig.inputDataFolder{1} = 'checkStageDataPresence_TEST/case_singleInputFolder/present/inputDir1/';
[list_data, isMissingData] = checkStageDataPresence(stageConfig, goodSubjectsIndices);

% dataA_1 and dataB_2 missing case
stageConfig.inputDataFolder{1} = 'checkStageDataPresence_TEST/case_singleInputFolder/missing/inputDir1/';
[list_data, isMissingData] = checkStageDataPresence(stageConfig, goodSubjectsIndices);

%% Loading data from individual subjects from MORE THAN ONE input folder (not supported yet)
% all files present case
stageConfig.inputDataFolder{1} = 'checkStageDataPresence_TEST/case_mulitpleInputFolder/present/inputDir1/';
stageConfig.inputDataFolder{2} = 'checkStageDataPresence_TEST/case_mulitpleInputFolder/present/inputDir2/';

[list_data, isMissingData] = checkStageDataPresence(stageConfig, goodSubjectsIndices);

% dataA_1 and dataB_2 missing case
stageConfig.inputDataFolder{1} = 'checkStageDataPresence_TEST/case_mulitpleInputFolder/missing/inputDir1/';
stageConfig.inputDataFolder{2} = 'checkStageDataPresence_TEST/case_mulitpleInputFolder/missing/inputDir2/';

[list_data, isMissingData] = checkStageDataPresence(stageConfig, goodSubjectsIndices);
