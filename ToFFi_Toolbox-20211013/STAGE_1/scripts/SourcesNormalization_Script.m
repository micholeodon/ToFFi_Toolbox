disp('Normalizing power spectra ...')

cfg = [];
cfg.method = CFG.STAGE_1.normalizationMethod;
cfg.sourceModel = CFG.Global.sourceAtlasAndSourceModel.sourceModel;

nAtlases = numel(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas);
if(nAtlases > 1)    
    iAtlas = iGoodSub;
    cfg.sourceAtlasSingle = ...
        CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(iAtlas);
else
    cfg.sourceAtlasSingle = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1);
end

normalizedSourcesPower.powerSpectrum  = normalizeActivity(cfg, sourcesPower);

clear sourcesPower % to save memory

cfg = [];
cfg.name = 'normalizedSourcesPower.powerSpectrum';
checkMatrix_Warn_NaN_or_Infinities(cfg, normalizedSourcesPower.powerSpectrum);

normalizedSourcesPower.freqAxis         = finalSourcesPowerStruct.freq;
normalizedSourcesPower.dimord           = finalSourcesPowerStruct.dimord;
normalizedSourcesPower.label            = finalSourcesPowerStruct.label;
