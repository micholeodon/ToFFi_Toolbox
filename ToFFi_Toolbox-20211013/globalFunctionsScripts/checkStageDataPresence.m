function [list_data, isMissingData] = checkStageDataPresence(stageConfig, goodSubjectsIndices)
%%
% Checks if data for selected stage is present, based on the data from
% provided configuration variable. When second argument (which is optional)
% is provided it takes into account data related to subjects listed in
% goodSubjectIndices. 
%
% NOTE ! Call it with one argument if input data is not divided into separate
% subject directories, otherwise call it with two arguments.
%
% Depends on: getFilesMatchingName.m,  makeSubjectAndDataLists.m
%% Inputs
% *stageConfig* - struct; contains fields with configuration variables of
% single stage, i.e. one of the fields from CFG variable. Used fields:
%
% _inputDataFolder_ - cell containing paths to directories with the input data.
%
% _dataNamesList_ - cell containing names of the files which presence will be
%                   checked.
%
% *goodSubjectsIndices* - (optional) double; array of good subject indices
%                         i.e whose data are permitted to be on the output
%                         list. For stages where stage data are not
%                         subject-specific user SHOULD NOT call function with
%                         two arguments, but only with first argument!
%
%% Outputs
% *list_data* - array of struct; each struct is related to one good
%               subject. Each field contain a file name that was found.
%
% *isDataMissing* - 0 or 1; 1 indicates that not all of intended data were
%                   found. Warning! Current version of this function throws
%                   error when isDataMissing == 1
%%

if(~isfield(stageConfig, 'inputDataFolder')) error('No inputDataFolder field in stage CFG !'); end
if(~isfield(stageConfig, 'dataNamesList')) error('No dataNamesList field in stage CFG !'); end

nInputDirs = length(stageConfig.inputDataFolder);

if(length(stageConfig.dataNamesList) == 0)
    warning('WARNING! No data names are provided in config_.m . Was it intensional?');
    warning('No control over data names will be provided. Proceed with care !');
    list_data = [];
    isMissingData = 0;
else
    if(nargin == 1)
	% check stage data presence
	isMissingData = 0;

	for iDataName = 1:length(stageConfig.dataNamesList)
	    isFound = 0;

	    fieldName = stageConfig.dataNamesList{iDataName};
	    dataName  = stageConfig.dataNamesList{iDataName};

	    for iInputDir = 1:nInputDirs
		waste_output= evalc('list_data.(fieldName) = getFilesMatchingName(dataName, stageConfig.inputDataFolder{iInputDir})');

		if(~isempty(list_data.(fieldName)))
		    isFound = 1;
		    break;
		end
	    end
	    if(isFound == 0)
		isMissingData = 1;
	    end

	end

	disp('This is group analysis. No subject-level data.')
	disp('Group data files needed are: ')
	disp(stageConfig.dataNamesList')

    elseif(nargin == 2)
	stageConfig.inputDataFolder
	if(nInputDirs > 1)
	    error('ERROR: Loading data from individual subjects data from many stages output is not supported yet !');
	end

	% check stage data presence
	[list_data, ~, isMissingData ] = makeSubjectAndDataLists('Sub_', ...
	    stageConfig.inputDataFolder{1}, ...
	    stageConfig.dataNamesList, ...
	    goodSubjectsIndices);

	disp('For particular subject, here e.g. subject 1, data files needed are: ')
	disp(list_data(1))
	disp('Check if any data are missing ...')
    else
	error('Zero or too many arguments provided !');
    end

    if(isMissingData)
	error('Some data are missing !');
    else
	disp('OK - no missing data.');
    end
end
