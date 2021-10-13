function checkSourcesPower(sourcesPower)
%%
% Check if data structure (sourcesPower) contains necessary fields and
% correct values.
%% Inputs
% *sourcesPower* - struct with fields:
%
% _powerSpectrum_ - double; 3D array that contains values of
%                   normalized power spectrum for each time segment,
%                   source/sensor and frequency.
%                   Size: trials x sources x frequencies.
%
% _freqAxis_ - double; 1D-array of frequencies in Hz. Should match the size
%              of the third dimension of _powerSpectrum_ field.
%
% _dimord_ - char; should equal 'rpt_chan_freq_'
%
% _label_ - cell containing char names of the sources.
%
%%
disp('Checking sourcePower ...')
% missing fields
if(~isstruct(sourcesPower)) error('sourcesPower is not a structure !'); end
if(~isfield(sourcesPower, 'powerSpectrum')) error('sourcesPower: powerSpectrum field missing'); end
if(~isfield(sourcesPower, 'freqAxis')) error('sourcesPower: freqAxis field missing'); end
if(~isfield(sourcesPower, 'dimord')) error('sourcesPower: dimord field missing'); end
if(~isfield(sourcesPower, 'label')) error('sourcesPower: label field missing'); end
% NaN-s
if(any(any(isnan([sourcesPower.powerSpectrum])))) error('sourcesPower: contains NaNs !'); end
if(any(any(isnan([sourcesPower.freqAxis])))) error('sourcesPower.freqAxis: contains NaNs !'); end
% Infinities
if(any(any(isinf([sourcesPower.powerSpectrum])))) error('sourcesPower: contains Infinities (Inf) !'); end
if(any(any(isinf([sourcesPower.freqAxis])))) error('sourcesPower.freqAxis: contains Infinities (Inf) !'); end

nTrials         = size(sourcesPower.powerSpectrum,1);
nSources        = size(sourcesPower.powerSpectrum,2);
nFrequencies    = size(sourcesPower.powerSpectrum,3);
nLabels         = length(sourcesPower.label);

% labels and num sources do not match
if(nSources ~= nLabels) error('Number of labels do not match number of sources !'); end

% two same labels
[~, repeatsCount] = computeStringRepeats(sourcesPower.label);
if(any([repeatsCount{:}] > 1)) error('Sensor labels repeat !'); end
