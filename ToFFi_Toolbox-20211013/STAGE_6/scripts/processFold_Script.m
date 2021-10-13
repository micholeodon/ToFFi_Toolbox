disp(['fold = ', num2str(iFold)])

trSub = goodSub(find(CV_singleRep.cvPart.training(iFold))');
vaSub = goodSub(find(CV_singleRep.cvPart.test(iFold))');
nSubTr = numel(trSub); % careful with indexing!
nSubVa = numel(vaSub); % careful with indexing!

nLogLMatrix = nan(nGoodROI, nGoodROI, nSubVa); % careful with indexing!

Training_Script

Testing_Script

Measures_Script

if(CFG.(STAGE_NAME).CV.save_NLL_Matrices)
    NLL_singleRep.iRep = iRep;
    NLL_singleRep.Folds(iFold).nLogL = nLogLMatrix;
end
