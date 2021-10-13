cfg = [];
cfg.variablePrefix  = 'CV';
cfg.thingPrefix     = 'iRep';
cfg.thingIndex      = iRep;
cfg.tmpFolder       = '../output/not_integrated/';
saveCoreResult_1prefix(cfg, CV_singleRep);


if(CFG.(STAGE_NAME).CV.save_NLL_Matrices)
    cfg = [];
    cfg.variablePrefix  = 'NLL_Matrix';
    cfg.thingPrefix     = 'iRep';
    cfg.thingIndex      = iRep;
    cfg.tmpFolder       = '../output/not_integrated/';
    saveCoreResult_1prefix(cfg, NLL_singleRep);
end