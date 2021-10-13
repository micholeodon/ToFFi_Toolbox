function s = estimateSfModeStd(SF)
% For each mode in spectral fingerprint it estimates standard deviation
% at each frequency from Gaussian Mixture Model covariance matrices.
%
% Input: SF - spectral fingerprint
% Outut s - 2D array, rows for modes, columns for frequencies

gmm = SF.lvl2_gmm_gmClassInstance;
nModes = gmm.NumComponents;
nFreq = numel(SF.freqAxis);


s = zeros(nModes, nFreq);
for iMode = 1:nModes
    S = gmm.Sigma(:,:,iMode);
    
    s(iMode,:) = sqrt(diag(S));
end
