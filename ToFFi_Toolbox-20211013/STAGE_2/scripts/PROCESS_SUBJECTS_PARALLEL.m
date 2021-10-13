subjectIndicesInThisJob = getIndices_S2(CFG.Global, jobInfo)

nSubInThisJob = length(subjectIndicesInThisJob)
nGoodRoi = length(CFG.Global.goodROI);
for iGoodSub = 1:nSubInThisJob
    disp(['iGoodSub: ', num2str(iGoodSub), ' / ', num2str(nSubInThisJob), ' ...']);
    iSub = CFG.Global.goodSubjects(subjectIndicesInThisJob(iGoodSub));

    loadSingleSubjectData
    checkLoadedDataNames

    for iGoodRoi = 1:nGoodRoi
	iROI = CFG.Global.goodROI(iGoodRoi);
	CORE(CFG, normalizedSourcesPower, iSub, iROI, MODE, ...
	     jobInfo);
    end
end

closeParpool
