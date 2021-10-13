cfg = [];
%cfg.mode = 'rand'; % uncomment to compute mean activation from random selected voxels from that ROI (no voxel repeats) - turning ROI size factor off
%cfg.numRandVox = 6; % uncomment to compute mean activation from random selected voxels from that ROI (no voxel repeats) - turning ROI size factor off
cfg.iGoodSub = find(ismember(CFG.Global.goodSubjects, iSub));
cfg.sourceAtlasAndSourceModel = CFG.Global.sourceAtlasAndSourceModel;
singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials = computeMeanRoiPower(cfg, ...
                                                  iSub, iROI, normalizedSourcesPower);
