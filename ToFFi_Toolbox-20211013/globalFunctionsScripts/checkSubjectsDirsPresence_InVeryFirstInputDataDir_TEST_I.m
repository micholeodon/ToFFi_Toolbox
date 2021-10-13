clear; close all; clc;

% TEST_I = interactive test - user needed ;)

% function checkSubjectsDirsPresence_InVeryFirstInputDataDir(globalConfig)
globalConfig.goodSubjects = [ 2 1 3 ];

%%


globalConfig.veryFirstInputDataDir = 'checkSubjectsDirsPresence_InVeryFirstInputDataDir_TEST/present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(globalConfig.veryFirstInputDataDir, globalConfig.goodSubjects)
assert(~isMissingSubjectDirs)

globalConfig.veryFirstInputDataDir = 'checkSubjectsDirsPresence_InVeryFirstInputDataDir_TEST/non_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(globalConfig.veryFirstInputDataDir, globalConfig.goodSubjects)
assert(logical(isMissingSubjectDirs))


globalConfig.veryFirstInputDataDir = 'checkSubjectsDirsPresence_InVeryFirstInputDataDir_TEST/more_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(globalConfig.veryFirstInputDataDir, globalConfig.goodSubjects)
assert(~isMissingSubjectDirs)


globalConfig.veryFirstInputDataDir = 'checkSubjectsDirsPresence_InVeryFirstInputDataDir_TEST/less_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(globalConfig.veryFirstInputDataDir, globalConfig.goodSubjects)
assert(logical(isMissingSubjectDirs))
