function  [pf, pf_pow] = getPeakFrequency(spectralMode, freqAxis)
% spectralMode - vector of spectral mode power values
% freqAxis - vector of frequencies
% pf - peak frequency
% pf_pow - spectral mode power value at peak frequency

[~, pf_idx] = max(abs(spectralMode));
pf_pow = spectralMode(pf_idx);
pf = freqAxis(pf_idx);
