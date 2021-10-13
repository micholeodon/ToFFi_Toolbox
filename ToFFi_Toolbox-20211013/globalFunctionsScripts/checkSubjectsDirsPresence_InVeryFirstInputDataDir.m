function checkSubjectsDirsPresence_InVeryFirstInputDataDir(globalConfig)
%%
% Function that checks if input data directiores for the STAGE_1 are present,
% according to the names in global configuration variable (input argument).
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
%                  stages. Used fields:
%
% _veryFirstInputDataDir_ - char; path containing input data for STAGE_1
%
% _goodSubjects_ - double; subject indices to include in processing
%%

globalConfig.veryFirstInputDataDir = fixPath(globalConfig.veryFirstInputDataDir);

isMissingSubjectDirs = checkSubjectsDirsPresence(...
    globalConfig.veryFirstInputDataDir, globalConfig.goodSubjects);

if(isMissingSubjectDirs)

    doProceed = askQuestion(['Directories of some subjects are missing. ' ...
	'Do you want to continue?'], {'y','n'});

    if(strcmp(doProceed,'n')) error('Aborted.'); end

 else
    disp('All subject directories present !')

end
