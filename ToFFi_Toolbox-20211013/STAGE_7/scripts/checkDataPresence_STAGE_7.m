nGoodSub = numel(CFG.Global.goodSubjects);
nGoodRoi = numel(CFG.Global.goodROI);

for iGoodSub = 1:nGoodSub
    iSub = CFG.Global.goodSubjects(iGoodSub)
    for iGoodRoi = 1:nGoodRoi
        iROI = CFG.Global.goodROI(iGoodRoi)

        if(~exist(fname), 'file')
            error(['ERROR ! Missing input data file for SUB=', num2str(iSub), ' , ROI=', num2str(iROI), '!!!'])
        end

    end % iGoodRoi
end % iGoodSub

disp('Input data existence checked')
