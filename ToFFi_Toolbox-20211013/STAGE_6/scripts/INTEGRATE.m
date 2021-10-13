% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../output/CFG.mat')  % stage config contains global config parameters
addpath ../functions
addGlobalFunctions(CFG.Global)
setupFieldtrip(CFG.Global)

notIntegratedFolder = '../output/not_integrated/';


% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
roiLabels   = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
nRoiAtlas   = length(roiLabels);
goodRoi     = CFG.Global.goodROI;
nGoodRoi    = length(goodRoi);
nReps       = CFG.STAGE_6.CV.nRepetitions;
nFolds       = CFG.STAGE_6.CV.nFolds;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INTEGRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errorDuringIntegrationException = [];
try

    % init field of output structure
    prepareOutputStructure

    for iRep = 1:nReps
	disp([  'Integrating repetition: ', num2str(iRep), ' / ', num2str(nReps), ' ...']);

	% CV
	partFile = [notIntegratedFolder, 'CV_iRep', num2str(iRep)];
	load(partFile)
	appendFields

	% NLogL
	if(CFG.STAGE_6.CV.save_NLL_Matrices)
	    partFile = [notIntegratedFolder, 'NLL_Matrix_iRep', num2str(iRep)];
	    load(partFile)
	    NLOGL.Reps(iRep) = NLL_singleRep;
	end

    end % nReps

    % Average results across reps
    ACC = zeros(nReps, nGoodRoi);
    MR = zeros(nReps, nGoodRoi);
    for iRep = 1:nReps
	ACC(iRep, :) = CV(iRep).accRoiMeanFolds(goodRoi);
	MR(iRep, :) = CV(iRep).meanRankRoiMeanFolds(goodRoi);
    end
    ACC_m = mean(ACC,1);
    MR_m = mean(MR,1);
    ACC_std = std(ACC,0,1);
    MR_std = std(MR,0,1);

    classificationResult.nReps = nReps;
    classificationResult.nFolds = nFolds;
    classificationResult.CV_reps = CV;


    classificationResult.accPerRoiMeanReps = zeros(1, nRoiAtlas);
    classificationResult.accPerRoiMeanReps(goodRoi) = ACC_m;

    classificationResult.acc_std_PerRoiStdReps = zeros(1, nRoiAtlas);
    classificationResult.acc_std_PerRoiStdReps(goodRoi) = ACC_std;

    classificationResult.meanRankPerRoiMeanReps = zeros(1, nRoiAtlas);
    classificationResult.meanRankPerRoiMeanReps(goodRoi) = MR_m;

    classificationResult.meanRank_std_PerRoiStdReps = zeros(1, nRoiAtlas);
    classificationResult.meanRank_std_PerRoiStdReps(goodRoi) = MR_std;

    disp('Saving data ...');

    % CV
    fileName = [CFG.STAGE_6.outputDataFolder, 'classificationResult.mat'];
    save(fileName, 'classificationResult', '-v7.3')
    if(~exist(fileName, 'file'))
	error('File somehow not saved !')
    end

    % NLogL
    if(CFG.STAGE_6.CV.save_NLL_Matrices)
	fileName = [CFG.STAGE_6.outputDataFolder, 'NLOGL.mat'];
	save(fileName, 'NLOGL', '-v7.3')
	if(~exist(fileName, 'file'))
	    error('File somehow not saved !')
	end
    end % if

catch errorDuringIntegrationException
    warning('Something wrong happened during integration ! not-integrated files will not be clead for safety !');
    fprintf(1,'The identifier was:\n%s',errorDuringIntegrationException.identifier);
    fprintf(1,'There was an error! The message was:\n%s',errorDuringIntegrationException.message);
    disp('Integration finished with errors.');

end % try

if isempty(errorDuringIntegrationException)
    cleanNotIntegratedFolder(notIntegratedFolder);
    disp('Integration DONE !');
end
