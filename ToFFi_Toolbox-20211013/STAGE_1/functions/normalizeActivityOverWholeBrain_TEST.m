clear; close all; clc;

% DO NOT CHANGE ANY VALUE !

% function sourcesNormalizedActivity = normalizeActivityOverWholeBrain(cfg, sourcesPower)

nTrials         = 2;
nAllVoxels      = 6;
nFrequencies    = 2;

voxelsSpectraTrials = 2*ones(nTrials, nAllVoxels, nFrequencies);
voxelsSpectraTrials(:,:,2) = 4*ones(nTrials, nAllVoxels, nFrequencies/2);

cfg = [];
[normalizedVoxelsSpectra] = normalizeActivityOverWholeBrain(cfg, voxelsSpectraTrials);

expected_result(:,:,1) = [1 1 1 1 1 1; 1 1 1 1 1 1];
expected_result(:,:,2) = [1 1 1 1 1 1; 1 1 1 1 1 1];

check1 = isequal(normalizedVoxelsSpectra(:,:,1), expected_result(:,:,1));
check2 = isequal(normalizedVoxelsSpectra(:,:,2), expected_result(:,:,2));

if(check1 && check2)
    disp 'Test passed.'
else
    disp 'Test FAILED.'
end