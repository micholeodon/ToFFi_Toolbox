clear; close all; clc;

% DO NOT CHANGE ANY VALUE !

%function [normalizedVoxelsSpectra, isEmptySelection] = normalizeSpectraInSelectedVoxels(cfg, voxelsSpectraTrials)
nTrials         = 2;
nAllVoxels      = 6;
nFrequencies    = 2;

voxelsSpectraTrials = 2*ones(nTrials, nAllVoxels, nFrequencies);
voxelsSpectraTrials(:,:,2) = 4*ones(nTrials, nAllVoxels, nFrequencies/2);

cfg = [];
cfg.selectedVoxels = 3:5;

[normalizedVoxelsSpectra, isEmptySelection] = normalizeSpectraInSelectedVoxels(cfg, voxelsSpectraTrials);

expected_result(:,:,1) = [2 2 1 1 1 2; 2 2 1 1 1 2];
expected_result(:,:,2) = [4 4 1 1 1 4; 4 4 1 1 1 4];

check1 = isequal(normalizedVoxelsSpectra(:,:,1), expected_result(:,:,1));
check2 = isequal(normalizedVoxelsSpectra(:,:,2), expected_result(:,:,2));
check3 = isEmptySelection == 0;

if(check1 && check2 && check3)
    disp 'Test passed.'
else
    disp 'Test FAILED.'
end