function  checkSubjectsDataPresence_InVeryFirstInputDataDir(globalConfig)
%%
% Function that check if input data for the STAGE_1 are present,
% according to the names in global configuration variable (input argument).
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
% stages. Used fields:
%
% _veryFirstInputDataDir_ - char; path containing input data for STAGE_1
%
% _veryFirstInputDataFileNames_ - cell; chars with names of files to check
% for existence in input directory to STAGE_1  (e.g. {'data_', 'filter_'} ; note
% underscore added at the end!).
%
% _goodSubjects_ - double; subject indices to include in processing
%
%%

globalConfig.veryFirstInputDataDir = fixPath(globalConfig.veryFirstInputDataDir);

SUB_DIR_PREFIX = 'Sub_';

% use List to list of subjects and list of data
[~, list_subjects, isMissingData] = makeSubjectAndDataLists(SUB_DIR_PREFIX, ...
    globalConfig.veryFirstInputDataDir, ...
    globalConfig.veryFirstInputDataFileNames, ...
    globalConfig.goodSubjects);

% warn user when data there is uneven data presence in folder (e.g. sub 5 is
% missing his data)
if(isMissingData)
    warning('For some subjects data are missing !');
    doProceed = askQuestion(['For some subjects data are missing. ' ...
	'Do you want to continue?'], {'y','n'});

    if(strcmp(doProceed,'n')) error('Aborted.'); end

else
    disp('Subject data present ! Continuing.');
end
