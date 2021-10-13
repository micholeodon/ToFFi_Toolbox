function sourceTimeSeries = sourceProjection(cfg, data, spatialFilter)
%%
% Calculates product of data matrix and spatial filter matrix in order to
% perform source activity reconstruction.
%
% More on the topic:
% [1] K. Sekihara and S. S. Nagarajan, Adaptive Spatial Filters for
%     Electromagnetic Brain Imaging. Berlin Heidelberg: Springer-Verlag, 2008.
%% Inputs
% *cfg* - [] (empty) in current version.
%
% *data* - structure containing following fields:
%
% _trial_ - cell containing 2D-arrays (sensors x time frames) signal values for
% single epochs of the multichannel signal (time segments).
%
% _time_ - cell containing 1D-arrays (1 x time frames) containing time
% values for single epochs of the multichannel signal (time segments).
%
% _label_ - cell containing names of the sensors (e.g. EEG electodes, MEG squids).
%
% _fsample_ - double; sampling frequency in Hz
%
% *spatialFilter* - double; 2D-array which represents spatial filter
%                   coefficients used for reconstruction on brain activity
%                   from sensors signal (see e.g. Van Veen 1997 to learn
%                   about LCMV spatial filter).
%% Outputs
% *sourceTimeSeries* - structure containing following fields:
%
% _trial_ - cell containing 2D-arrays (sources x time frames) reconstructed
% source activity signal values for single epochs (time segments).
%
% _time_ - cell containing 1D-arrays (1 x time frames) containing time
% values for single epochs of the reconstructed activity signal.
%
% _fsample_ - double; sampling frequency in Hz
%
% _label_ - cell containing working names of the sources
%           ({'src_1', 'src_2', ..., 'src_5998}).
%%

disp('Source projection ...')

% SOURCE PROJECTION: apply weights to a sensor signal
numTrials                    = length(data.trial);
numSources                   = size(spatialFilter,1);
sourceTimeSeries.trial    = cell(1, numTrials);
sourceTimeSeries.time     = data.time;
sourceTimeSeries.fsample  = data.fsample;
sourceTimeSeries.label    = cell(numSources, 1); % labels are needed to perform ft_freqanalysis
for src = 1:numSources
    sourceTimeSeries.label{src} = ['src_', num2str(src)];
end

% source projection: q = Wy
for tt = 1:numTrials
    sourceTimeSeries.trial{tt} = spatialFilter*data.trial{tt};
end

if(isfield(data, 'sampleinfo'))
    sourceTimeSeries.sampleinfo = data.sampleinfo;
end
