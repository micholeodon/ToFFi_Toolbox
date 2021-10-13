function CORE(CFG, MODE, list_data, jobInfo)

STAGE_NAME = 'STAGE_8';

%%
CoreInit_Script

%%
switch MODE
    case 'serial'
      PROCESS_ROI_SERIAL

    case 'parallel'
      PROCESS_ROI_PARALLEL

    otherwise
	error('ERROR ! Wrong MODE value (should be ''serial'' or ''parallel'' !');
end % switch


cfg = [];
cfg.goodRows            = goodROI;
cfg.goodCols            = goodROI;
cfg.observationsLabels  = roiLabels;
networkAnalysisResult.binaryLinkage = binaryLinkageAnalysis(cfg, CFG.(STAGE_NAME), fitMatrix);
networkAnalysisResult.fitMatrix = fitMatrix;

% save output
save('../output/networkAnalysisResult.mat', 'networkAnalysisResult')

disp('CORE done.');
