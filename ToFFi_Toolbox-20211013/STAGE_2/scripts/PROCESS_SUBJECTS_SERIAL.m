nGoodSub = length(CFG.Global.goodSubjects);
nGoodRoi = length(CFG.Global.goodROI);
for iGoodSub = 1:nGoodSub
    disp(['iGoodSub: ', num2str(iGoodSub), ' / ', num2str(nGoodSub), ' ...']);
    iSub = CFG.Global.goodSubjects(iGoodSub);

    loadSingleSubjectData
    checkLoadedDataNames

    for iGoodRoi = 1:nGoodRoi
	iROI = CFG.Global.goodROI(iGoodRoi);
	CORE(CFG, normalizedSourcesPower, iSub, iROI, MODE, []);
    end
end
