function checkDataAndFilter(data, spatialFilter)
%%
% Function that checks if all necessary fields are present in the *data*
% structure and if there are any NaNs or Infs in the *spatialFilter*.
%% Inputs
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
% *spatialFilter* - double; 2D-array which represents spatial filter
%                   coefficients used for reconstruction on brain activity
%                   from sensors signal (see e.g. Van Veen 1997 to learn
%                   about LCMV spatial filter)
%%

disp('Checking data and filter ...')
% missing fields
if(~isstruct(data)) error('data input is not a structure !'); end
if(~isfield(data, 'trial')) error('data: trial field missing'); end
if(~isfield(data, 'time')) error('data: time field missing'); end
if(~isfield(data, 'label')) error('data: label field missing'); end
if(~isfield(data, 'fsample')) error('data: fsample field missing'); end
% not a matrix
if(~ismatrix(spatialFilter)) error('filter input should be a matrix (numSources x numChannels) !'); end
if(~ismatrix(spatialFilter)) error('filter input should be a matrix (numSources x numChannels) !'); end
% NaN-s
if(any(any(isnan([data.trial{:}])))) error('data: contains NaNs !'); end
if(any(any(isnan([data.time{:}])))) error('data.time: contains NaNs !'); end
if(isnan(data.fsample)) error('data.fsample: is NaNs !'); end
if(any(any(isnan(spatialFilter)))) error('filter: contains NaNs !'); end
% Infinities
if(any(any(isinf([data.trial{:}])))) error('data: contains Infinities (Inf) !'); end
if(any(any(isinf([data.time{:}])))) error('data.time: contains Infinities (Inf) !'); end
if(isinf(data.fsample)) error('data.fsample: is Infinities (Inf) !'); end
if(any(any(isinf(spatialFilter)))) error('filter: contains Infinities (Inf) !'); end


% if somebody accidentaly transposed matrix it could not match the data
% try to multiply both ways to see which will work
try
    spatialFilter*data.trial{1};
catch
    try
	spatialFilter'*data.trial{1};
	error('Transpose filter matrix before use!');
    catch
	error('data matrix and filter do not match ! Check them.')
    end
end
