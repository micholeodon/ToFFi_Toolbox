switch CFG.STAGE_1.dummySignalMode

  case 'no'
    cfg = [];
    sourcesTimeSeries   = sourceProjection(cfg, data, spatialFilter);
  case 'wgn'
    cfg = [];
    cfg.keepTrials = 'no';
    sourcesTimeSeries    = inputWhiteGaussianSourceNoise(cfg, data, spatialFilter);
  case 'wgn-keepTrials'
    cfg = [];
    cfg.keepTrials = 'yes';
    sourcesTimeSeries    = inputWhiteGaussianSourceNoise(cfg, data, spatialFilter);
  case 'sine'
    cfg = [];
    cfg.keepTrials = 'no';
    sourcesTimeSeries    = inputSineSourceSignal(cfg, data, spatialFilter);
  case 'sine-keepTrials'
    cfg = [];
    cfg.keepTrials = 'yes';
    sourcesTimeSeries    = inputSineSourceSignal(cfg, data, spatialFilter);
  otherwise
    error('ERROR ! Wrong value of CFG.STAGE_1.dummySignalMode variable !')

end
