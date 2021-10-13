function [normalizedVoxelsSpectra, isEmptySelection] = normalizeSpectraInSelectedVoxels(cfg, voxelsSpectraTrials)
%%
% Normalizes power spectrum values inside voxelsSpectraTrials matrix so each
% becomes a ratio of the average power spectrum of selected voxels and all
% time segments.
% This normalisation results in values above/below one. Size of the input
% structure is left intact.
%% Inputs
% *cfg* - struct with fields:
%
% _selectedVoxels_ - double; array with integers - indices of selected voxels
%                    to be normalized by their average power spectrum across all
%                    time segments and across all selected voxels
%
% *voxelsSpectraTrials* - double; 3D array that contains values of power
%                         spectrum for each time segment, voxel and
%                         frequency. Size: trials x voxels x frequencies.
%% Outputs
% *normalizedVoxelsSpectra* - double; 3D array that contains values of
%                             normalized power spectrum for each time segment,
%                             voxel/sensor and frequency.
%                             Size: trials x voxels x frequencies.
%
% *isEmptySelection* - double; 0 or 1; flag that show if cfg.selectedVoxels
%                      is empty (by accident or sth).
%%

if(~isfield(cfg, 'selectedVoxels')) error('No cfg.selectedVoxels field in cfg argument !'); end

nTrials             = size(voxelsSpectraTrials,1);
nSelectedVoxels     = length(cfg.selectedVoxels);
nAllVoxels          = size(voxelsSpectraTrials,2);
nFrequencies        = size(voxelsSpectraTrials,3);

if(any(cfg.selectedVoxels > nAllVoxels)) error('Selected indices outside of range!'); end
if(any(cfg.selectedVoxels < 1)) error('Non-positive indices not permited !'); end


if(nSelectedVoxels == 0)
    warning('No voxels selected. Skipping normalization.');
    normalizedVoxelsSpectra = [];
    isEmptySelection = 1;
    return;
else
    isEmptySelection = 0;
end

meanSpectrumAcrossTrials            = nanmean( voxelsSpectraTrials(:,cfg.selectedVoxels,:), 1);
meanSpectrumAcrossTrialsAndVoxels   = nanmean(meanSpectrumAcrossTrials,2);
avgSpectrum                         = squeeze(meanSpectrumAcrossTrialsAndVoxels); % nFrequencies x 1
assert(isequal(size(avgSpectrum), [nFrequencies 1]))
repeatedAvgSpectrum                 = repmat(avgSpectrum',[nSelectedVoxels 1]); % nSelectedVoxels x nFrequencies
assert(isequal(size(repeatedAvgSpectrum), [nSelectedVoxels nFrequencies]))

normalizedVoxelsSpectra = voxelsSpectraTrials;

for iTrial = 1:nTrials
    normalizedVoxelsSpectra(iTrial, cfg.selectedVoxels, :) = ...
	(reshape(voxelsSpectraTrials(iTrial, cfg.selectedVoxels, :), nSelectedVoxels, nFrequencies)) ...
							    ./ repeatedAvgSpectrum; % reshape to avoid squeezing any dimension accidentaly
end
assert(isequal(size(normalizedVoxelsSpectra), [nTrials nAllVoxels ...
		    nFrequencies]))
