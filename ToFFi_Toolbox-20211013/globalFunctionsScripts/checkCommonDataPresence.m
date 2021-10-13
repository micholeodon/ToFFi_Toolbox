function checkCommonDataPresence(globalConfig)
%%
% Check whether all necessary data common for all stages of processing are
% present in directory specified in *globalConfig.commonDataDir*. This folder
% contains common source grids, common brain atlases.
%% Inputs
% *globalConfig* - struct; Holds configuration variables common for all
%                  stages. Used fields:
%
% _commonDataDir_ - char;  path to the directory with data used by all
%                   stages. Path relative to the *globalConfig.rootDir* (your
%                   repo root directory)
%%

% check if globalConfig contains right field
if(~isfield(globalConfig, 'commonDataDir')) error('ERROR: no field commonDataDir in struct globalConfig !'); end
globalConfig.commonDataDir = fixPath(globalConfig.commonDataDir);
if(~exist(globalConfig.commonDataDir, 'dir')) error('ERROR: Directory not exist !'); end


% fill this list with the filenames that are necessary for you analysis
listFiles = {'templategrid10mm', 'templategrid_HCP_8mm', ...
	     'Schaefer2018_100Parcels_7Networks_order_ATLAS.nii.gz', ...
	     'Schaefer2018_100Parcels_7Networks_order_ATLAS.nii.txt'};

nFiles = length(listFiles);
missing = zeros(1, nFiles);
for iFile = 1:nFiles

    listMatching = getFilesMatchingName(listFiles{iFile}, globalConfig.commonDataDir);
    missing(iFile) = isempty(listMatching);
end

iMissingList = find(missing);

if(~isempty(iMissingList))

    for iMissing = iMissingList
	warning([listFiles{iMissing}, ' file is missing !'])
    end

    doProceed = askQuestion('Some common files are missing. Do you want to continue with config?', {'y','n'});

    if(strcmp(doProceed, 'n')) disp('Aborted.'); end

else
    disp('All common files present !')
end
