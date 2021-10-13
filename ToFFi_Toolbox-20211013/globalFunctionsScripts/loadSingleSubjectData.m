%% script
% Load all data listed in single stage config according to .dataNamesList and
% inputDataFolder fields.
%%
if(~exist('STAGE_NAME', 'var')) error('Add STAGE_NAME = ''STAGE_? '' line in the CORE.m file !'); end

disp('Loading data ...')

nDataNames = length(CFG.(STAGE_NAME).dataNamesList);
nInputDirs = length(CFG.(STAGE_NAME).inputDataFolder);
for iName = 1:nDataNames
    timesLoaded = 0;

    dataName = [CFG.(STAGE_NAME).dataNamesList{iName}, '_', num2str(iSub')];
    subjectFolder = ['Sub_', num2str(iSub), '/'];

    for iInputDir = 1:nInputDirs

	dataFile = [CFG.(STAGE_NAME).inputDataFolder{iInputDir}, subjectFolder, ...
                dataName, '.mat'];
    dataFile = fixPath(dataFile);
	if(exist(dataFile, 'file'))
	    timesLoaded = timesLoaded + 1;
	    load(dataFile);
	end

	if(timesLoaded > 1)
	    error(['ERROR: Requested data file ', dataFile, ' present in more than one input folders of current stage !']);
	end
    end

end
