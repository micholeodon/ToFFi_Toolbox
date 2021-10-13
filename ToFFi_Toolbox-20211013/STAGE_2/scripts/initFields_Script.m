nGoodRoi   = length(CFG.Global.goodROI);
nAtlases   = numel(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas);

if(nAtlases>1) 
    nRoiAtlas  = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(iGoodSub).tissuelabel);
else
    nRoiAtlas  = length(CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel);
end
singleSubjectSingleRoiData.subjectID               = ['Sub_', num2str(iSub)];
singleSubjectSingleRoiData.iSub                    = iSub;
singleSubjectSingleRoiData.iROI                    = iROI;
if(nAtlases>1) 
    singleSubjectSingleRoiData.tissuelabels            = ...
        CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(iGoodSub).tissuelabel;
else
    singleSubjectSingleRoiData.tissuelabels            = ...
        CFG.Global.sourceAtlasAndSourceModel.sourceAtlas.tissuelabel;
end
singleSubjectSingleRoiData.goodROI                 = CFG.Global.goodROI;
singleSubjectSingleRoiData.nRoiAtlas               = nRoiAtlas;
singleSubjectSingleRoiData.normalizedPowerSpectrum_Trials = cell(1, nRoiAtlas);
singleSubjectSingleRoiData.freqAxis                = normalizedSourcesPower.freqAxis;
singleSubjectSingleRoiData.nTrials                 = size(normalizedSourcesPower.powerSpectrum, 1);
