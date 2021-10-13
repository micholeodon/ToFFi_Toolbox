function sourceTimeSeries = inputWhiteGaussianSourceNoise(cfg, data, spatialFilter)
%%
% Insert white gaussian noise in brain sources, instead of doing
% reconstruction.
% Noise is generated by dependent function generateWhiteNoise.m where you can
% define properties of the noise as desired.
%% Inputs
% *cfg* - [] (empty) in current version.
%
% *data* - structure containing following fields:
%
% _trial_ - cell containing 2D-arrays (sensors x time frames) signal values for
%           single epochs of the multichannel signal (time segments).
%
% _time_ - cell containing 1D-arrays (1 x time frames) containing time
%          values for single epochs of the multichannel signal (time segments).
%
% _label_ - cell containing names of the sensors (e.g. EEG electodes, MEG squids).
%
% _fsample_ - double; sampling frequency in Hz
%
% *spatialFilter* - double; 2D-array which is of size of spatial filter
%                   coefficients matrix used for reconstruction on brain activity
%                   from sensors signal (see e.g. Van Veen 1997 to learn
%                   about LCMV spatial filter). Can have random values but it
%                   must be of size sources x sensors.
%% Outputs
% *sourceTimeSeries* - structure containing following fields:
%
% _trial_ - cell containing 2D-arrays (sources x time frames) reconstructed
% source activity signal values for single epochs (time segments).
%
% _time_ - cell containing 1D-arrays (1 x time frames) containing time
% values for single epochs of the white gaussian noise.
%
% _fsample_ - double; sampling frequency in Hz
%
% _label_ - cell containing working names of the sources
%           ({'src_1', 'src_2', ..., 'src_5998}).
%%

disp('Putting white noise instead of source projection ...')

switch cfg.keepTrials
  case 'yes'
    % keep trials structure and length intact
    numTrials                 = length(data.trial);
    sourceTimeSeries.trial    = cell(1, numTrials);
    sourceTimeSeries.time     = data.time;
    sourceTimeSeries.fsample  = data.fsample;
  case 'no'
    numTrials                 = 300;
    sourceTimeSeries.trial    = cell(1, numTrials);
    time                      = cell(1, numTrials);
    for tt = 1:numTrials
	time{tt}              = 0:0.002:0.999;
    end
    sourceTimeSeries.time     = time;
    sourceTimeSeries.fsample  = 500;
  otherwise
    error('ERROR! Unrecognized value of cfg.keepTrials ! (should be ''yes'' or ''no'' ')
end

numSources                = size(spatialFilter,1);
sourceTimeSeries.label    = cell(numSources, 1); % labels are needed to perform ft_freqanalysis

for src = 1:numSources
    sourceTimeSeries.label{src} = ['src_', num2str(src)];
end


switch cfg.keepTrials
  case 'no'
    nSamples = size(time{1}, 2);
    for tt = 1:numTrials
	sourceTimeSeries.trial{tt} = generateWhiteNoise(numSources, nSamples);
    end
  case 'yes'
    for tt = 1:numTrials
	nSamples = size(data.trial{tt}, 2);
	sourceTimeSeries.trial{tt} = generateWhiteNoise(numSources, nSamples);
    end
  otherwise
    error('ERROR! Unrecognized value of cfg.keepTrials ! (should be ''yes'' or ''no'' ')
end

if(isfield(data, 'sampleinfo'))
    sourceTimeSeries.sampleinfo = data.sampleinfo;
end

disp('White noise injection DONE!')