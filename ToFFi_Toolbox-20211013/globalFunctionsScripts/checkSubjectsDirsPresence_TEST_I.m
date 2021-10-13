clear; close all; clc;

% TEST_I = interactive test - user needed !

% isMissingSubjectDirs = checkSubjectsDirsPresence(directory)


%% correct indices
indices = [2 1 3];

% (OK)
directory = 'checkSubjectsDirsPresence_TEST/present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (WARNINGS)
directory = 'checkSubjectsDirsPresence_TEST/non_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (WARNING)
directory = 'checkSubjectsDirsPresence_TEST/less_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (WARNING)
directory = 'checkSubjectsDirsPresence_TEST/more_present/';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (ERR)
directory = 'checkSubjectsDirsPresence_TEST/non_existent/';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

%% incorrect indices
directory = 'checkSubjectsDirsPresence_TEST/present/';

% (ERR)
indices = '';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (ERR)
indices = 'foo';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);

% (ERR)
indices = '[1, 2, 3]';
isMissingSubjectDirs = checkSubjectsDirsPresence(directory, indices);
