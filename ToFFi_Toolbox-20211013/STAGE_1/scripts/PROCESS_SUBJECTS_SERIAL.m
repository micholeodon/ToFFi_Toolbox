nGoodSub = length(CFG.Global.goodSubjects);
for iGoodSub = 1:nGoodSub
    iSub = CFG.Global.goodSubjects(iGoodSub);
    CORE(CFG, iSub, nGoodSub);
end
