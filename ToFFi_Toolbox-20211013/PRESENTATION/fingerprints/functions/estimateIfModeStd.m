function s = estimateIfModeStd(IF, iRoi)
% For each mode in spectral fingerprint it estimates standard deviation
% at each frequency from Gaussian Mixture Model covariance matrices.
%
% Input: IF - individual fingerprint, iRoi - ROI index
% Outut s - 2D array, rows for modes, columns for frequencies

gmm = IF.gmClassInstance{iRoi};
nModes = gmm.NumComponents;
nFreq = numel(IF.freqAxis);


s = zeros(nModes, nFreq);
for iMode = 1:nModes
    S = gmm.Sigma(:,:,iMode);
    
    s(iMode,:) = sqrt(diag(S));
end
