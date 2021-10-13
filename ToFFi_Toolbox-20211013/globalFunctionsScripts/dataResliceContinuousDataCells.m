function dataOut = dataResliceContinuousDataCells(cfg, data)
% Concatenate cells with data (assuming that they are continuous)
% then divide single cell with data to several cells.
%
% DANGER ! This function not preserve sampleinfo field (it is not present
% in the output structure) - to be corrected later if it will be needed.

disp('Data reslicing ...')

if(~isstruct(data)) error('data input is not a structure !'); end
if(~isfield(data, 'trial')) error('data: trial field missing'); end
if(~isfield(data, 'time')) error('data: time field missing'); end
if(~isfield(data, 'label')) error('data: label field missing'); end
if(~isfield(data, 'fsample')) error('data: fsample field missing'); end
if(~isfield(cfg, 'durationMillisec')) error('No durationMillisec field in cfg !'); end


%% Making data continuous
new_trial   = concatenateDataFromCells(data.trial);

t0                      = data.time{1}(1);
samplingTimeInterval    = 1/data.fsample;

%% Reslicing data to desired length
numberOfSamplesPerTrial = (cfg.durationMillisec / 1000) * round(data.fsample);

if(~isInteger(numberOfSamplesPerTrial))
    error(['1/Fsample = ', num2str(1000/round(data.fsample)), ' ms  is the smallest time interval possible. Check cfg.durationMillisec.']);
end

cfgReslice = [];
cfgReslice.numColumnsPerCell = numberOfSamplesPerTrial;
new_trial = divideDataToSeveralCells(cfgReslice, new_trial);

numSamplesPerTrial  = size(new_trial{1}, 2);
numTrials           = length(new_trial);
singleTrialTimeAxis = t0:samplingTimeInterval:(numSamplesPerTrial-1)*samplingTimeInterval;
tmp                 = {repmat(singleTrialTimeAxis,1, numTrials)};

cfgReslice = [];
cfgReslice.numCells = numTrials;
new_time = divideDataToSeveralCells(cfgReslice, tmp);

clear t0 samplingTimeInterval numSamplesPerTrial tmp

%% appending to output structure
dataOut.trial = new_trial;
dataOut.time = new_time;
dataOut.label = data.label;
dataOut.fsample = data.fsample;
