% Subroutine of networksPlot.m

disp 'Calculating ...'
sourceAtlas = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1);
atlasLabels = sourceAtlas.tissuelabel;
bl          = networkAnalysisResult.binaryLinkage;
leafRoiNumbers      = CFG.Global.goodROI(bl.TreeFull.leafNodesIndices);
leafLabels          = atlasLabels(leafRoiNumbers);
leafRoiNumberString = cellstr(num2str(leafRoiNumbers'));
goodRoi     = CFG.Global.goodROI;
nGoodRoi    = numel(goodRoi);

if(~isempty(cfg.treeLevel))
    if(cfg.treeLevel <= CFG.STAGE_8.nSimilarityClusters)
        treeLvl = cfg.treeLevel;
    else
        warning('cfg.treeLevel value too high! Displaying maximum possible level.')
        treeLvl = CFG.STAGE_8.nSimilarityClusters;
    end
else    
end

disp 'Calculating done!'
