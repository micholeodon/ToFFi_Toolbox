function sourcesNormalizedActivity = normalizeActivityOverWholeBrain(cfg, sourcesPower)
%%
% Normalizes power spectrum values inside sourcesPower matrix so each becomes
% a ratio of the average power spectrum of whole brain and all time segments.
% This normalisation results in values above/below one. Size of the input
% structure is left intact.
%
% Relies on normalizeSpectraInSelectedVoxels.m routine.
%% Inputs
% *cfg* - irrelevant for this method (can be empty i.e. equal []).
% *sourcesPower* - double; 3D array that contains values of power spectrum for
%                  each time segment (trial), source and frequency.
%                  Size: trials x sources x frequencies.
%% Outputs
% *sourcesNormalizedActivity* - double; 3D array that contains values of
%                               normalized power spectrum for each time
%                               segment (trial), source/sensor and frequency.
%                               Size: trials x sources x frequencies.
%%

disp('Normalize activity (ratio normalization, over whole brain) ...')

nSources                    = size(sourcesPower,2);

cfg.selectedVoxels          = 1:nSources;

if(nSources == 0)
    error('Number of sources is 0 !');
end

sourcesNormalizedActivity   = normalizeSpectraInSelectedVoxels(cfg, sourcesPower);
