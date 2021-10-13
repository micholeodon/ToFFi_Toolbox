clear; close all; clc;

% TEST_I = interactive test - user needed :)


% function  checkSubjectsDataPresence_InVeryFirstInputDataDir(globalConfig)


globalConfig.veryFirstInputDataDir = 'checkSubjectsDataPresence_InVeryFirstInputDataDir_TEST/present/';
checkSubjectsDataPresence_InVeryFirstInputDataDir(globalConfig)

clc
globalConfig.veryFirstInputDataDir = 'checkSubjectsDataPresence_InVeryFirstInputDataDir_TEST/non_present/';
checkSubjectsDataPresence_InVeryFirstInputDataDir(globalConfig)

clc
globalConfig.veryFirstInputDataDir = 'checkSubjectsDataPresence_InVeryFirstInputDataDir_TEST/partially_present/';
checkSubjectsDataPresence_InVeryFirstInputDataDir(globalConfig)