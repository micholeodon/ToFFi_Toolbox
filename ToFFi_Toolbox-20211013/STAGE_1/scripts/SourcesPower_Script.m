disp('Calculating power spectra for each time segment ...')

cfg = [];
cfg.frequencies = CFG.STAGE_1.frequenciesOfInterest;
% evalc to prevent command window from cluttering by output
[~] = evalc(['[finalSourcesPowerStruct, outputFrequencies] = ' ...
	     'fourierAnalysis_Method1(cfg, sourcesTimeSeries)']);

clear sourcesTimeSeries % to save memory
sourcesPower = finalSourcesPowerStruct.powspctrm;
