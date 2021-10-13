function sourcesNormalizedActivity  = normalizeActivity(cfg, sourcesPower)
%%
% Normalizes power spectrum values inside sourcesPower matrix so it becomes
% (depending on method of choice) a ratio of the average power spectrum of
% all brain and all time segments or ratio of the average power spectrum of
% inside given brain region and all time segments.
% This normalisation results in values above/below one.
%% Inputs
% *cfg* - struct containing fields:
%
% _method_ - char; Equals 'wholebrain' (divides each source power spectra by
%            the average spectrum computed from all time segments and ALL
%            sources), 'roiwise' (divide each source power spectra by the
%            average spectrum computed across time segments and sources
%            belonging to brain region of the divided source) or 'none'
%            (sourcesNormalizedActivity == sourcesPower).
%
% _sourceModel_ - struct; output of prepareSourceModel.m routine
%
% _sourceAtlasSingle_ - struct; single structure from sourceAtlas output of
%                       prepareAtlas.m routine 
%
% *sourcesPower* - double; 3D array that contains real values of power
%                  spectrum for each time segment (trial), source and frequency.
%                  Size: trials x sources x frequencies.
%% Outputs
% *sourcesNormalizedActivity* - double; 3D array that contains values of
%                               normalized power spectrum for each time
%                               segment (trial), source/sensor and frequency.
%                               Size: trials x sources x frequencies.
%%

if(~isfield(cfg, 'method'))
    error('No method field in cfg argument !');
end

switch cfg.method
    case 'wholebrain'
	sourcesNormalizedActivity   = normalizeActivityOverWholeBrain(cfg, sourcesPower);

    case 'roiwise'
	sourcesNormalizedActivity   = normalizeActivityROIwise(cfg, sourcesPower);

    case 'none'
	sourcesNormalizedActivity   = sourcesPower;

    otherwise
	error('Unrecognized normalization method !');

end
