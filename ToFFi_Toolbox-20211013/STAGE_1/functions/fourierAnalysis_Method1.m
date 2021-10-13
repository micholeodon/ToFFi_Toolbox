function [powSpectra, outputFrequencies] = fourierAnalysis_Method1(cfg, timeSeries)
%%
% Method calculating power spectra for each trial separately. Multitapering with
% Slepian tapers (DPSS).
% Wraps ft_freqanalysis (fieldtriptoolbox.org/reference/ft_freqanalysis/).
%% Inputs
% *cfg* - struct containing field:
%
% _frequencies_ - double; 1D-array of frequencies in Hz to calculate spectral
%                 power for.
%
% *timeSeries*  - struct; Output of sourceProjection.m routine.
%                 Contains following fields:
%
% _trial_ - cell containing 2D-arrays (sources x time frames) reconstructed
% source activity signal values for single epochs (time segments).
%
% _time_ - cell containing 1D-arrays (1 x time frames) containing time
% values for single epochs of the reconstructed activity signal.
%
% _fsample_ - double; sampling frequency in Hz
%
% _label_ - cell containing working char names of the sources or sensors
%
%% Outputs
% *powSpectra* - output structure from ft_freqanalysis.m
%                (https://www.fieldtriptoolbox.org/reference/ft_freqanalysis/).
%                Contains field (powspctrm) with power spectra for each time
%                segment source/sensor and freuquency.
%                Size: trials x sources x frequencies.
%
% *outputFrequencies* -  vector of frequencies (ft_freqanalysis may change
%                       cfg.frequencies to fit its other analysis parameters)
%%
%

disp('Spectrum calculation on each trial separately ...')

% Source spectral activity calculation
cfgFreq             = [];
cfgFreq.method      = 'mtmfft';
cfgFreq.output      = 'pow';
cfgFreq.taper       = 'dpss';
cfgFreq.tapsmofrq   = 2; % the amount of spectral smoothing through multi-tapering (+/- df)
cfgFreq.pad         = 2; % length in seconds to which the data can be padded out.
cfgFreq.keeptrials  = 'yes';
cfgFreq.foi         = cfg.frequencies;
powSpectra  = ft_freqanalysis(cfgFreq, timeSeries);
outputFrequencies   = powSpectra.freq;


% powSpectra.powspctrm is of size
% (nTrials) x nSources x nFrequencies
