% INIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../output/CFG.mat')  % stage config contains global config parameters
addpath ../functions
addGlobalFunctions(CFG.Global)
setupFieldtrip(CFG.Global)

notIntegratedFolder = '../output/not_integrated/';

nGoodSub        = length(CFG.Global.goodSubjects);
% configuration guarantees that labels are the same across all
% individual atlases, so I can write sourceAtlas(1).tissuelabel
roiLabels   = CFG.Global.sourceAtlasAndSourceModel.sourceAtlas(1).tissuelabel;
nRoiAtlas   = length(roiLabels);
nGoodRoi    = length(CFG.Global.goodROI);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INTEGRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
errorDuringIntegrationException = [];

% second file will be integrated as a one big cell array for simplicity
singleSubjectPowerData = cell(1,nRoiAtlas);

try
    for iGoodSub = 1:nGoodSub

	iSub = CFG.Global.goodSubjects(iGoodSub);

	%% FILE 1 - individual fingerprints %%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% init field of output structure
	individualFingerprint.subjectID     =   ['Sub_', num2str(iSub)];
	individualFingerprint.iSub          =   iSub;
	individualFingerprint.tissuelabels  =   roiLabels;
	individualFingerprint.nRoiAtlas     =   nRoiAtlas;
	individualFingerprint.goodROI       =   CFG.Global.goodROI;

	individualFingerprint.spectralModes =   cell(1, nRoiAtlas);
	individualFingerprint.trialsSpectralModeMembership = cell(1, nRoiAtlas);
	individualFingerprint.gmClassInstance = cell(1, nRoiAtlas);
	individualFingerprint.didGmmConverge = -ones(1, nRoiAtlas);
	individualFingerprint.clusterDuration = cell(1, nRoiAtlas);
	individualFingerprint.emptyClusters =   cell(1, nRoiAtlas);
	individualFingerprint.numberOfClustersInThisRoi = nan(1, nRoiAtlas);

	if(strcmp(CFG.STAGE_2.numClustersMode, 'optimal'))
	    individualFingerprint.optimalNumClustEvaluation = cell(1, nRoiAtlas);
	end

	for iGoodROI = 1:nGoodRoi
	    iROI = CFG.Global.goodROI(iGoodROI);
	    disp([  'FILE 1/2: Integrating Sub: ', num2str(iGoodSub), ' / ', num2str(nGoodSub), ...
		' ; ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ...'])

	    partFile = [notIntegratedFolder, 'individualFingerprint_iROI', ...
		num2str(iROI), '_iSub', num2str(iSub)];
	    load(partFile)

	    individualFingerprint.spectralModes{iROI}       = individualFingerprintSingleROI.spectralModes;
	    individualFingerprint.nTrials                   = individualFingerprintSingleROI.nTrials;
	    individualFingerprint.freqAxis                      = individualFingerprintSingleROI.freqAxis;
	    individualFingerprint.trialsSpectralModeMembership{iROI} =  individualFingerprintSingleROI.trialsSpectralModeMembership;
	    individualFingerprint.gmClassInstance{iROI}     =  individualFingerprintSingleROI.gmClassInstance;
	    individualFingerprint.didGmmConverge(iROI)     =  individualFingerprintSingleROI.didGmmConverge;
	    individualFingerprint.clusterDuration{iROI}   =  individualFingerprintSingleROI.clusterDuration;
	    individualFingerprint.emptyClusters{iROI}       = individualFingerprintSingleROI.emptyClusters;
	    individualFingerprint.numberOfClustersInThisRoi(iROI) = individualFingerprintSingleROI.numberOfClustersInThisRoi;
	    if(strcmp(CFG.STAGE_2.numClustersMode, 'optimal'))
		individualFingerprint.optimalNumClustEvaluation{iROI} = individualFingerprintSingleROI.optimalNumClustEvaluation;
	    end
	end % nGoodRoi loop

	disp([' FILE 1/2: Saving data for subject :', num2str(iGoodSub), ' / ', num2str(nGoodSub), ' ...']);
	subjectDir = [CFG.STAGE_2.outputDataFolder, 'Sub_', num2str(iSub), '/'];
	fileName = [subjectDir, 'individualFingerprint_', num2str(iSub), '.mat'];
	save(fileName, 'individualFingerprint', '-v7.3')

	%% FILE 2 - singleSubjectSingleRoiPowerData %%%%%%%%%%%%%%%%%%%%%%%%%%%%

	for iGoodROI = 1:nGoodRoi
	    iROI = CFG.Global.goodROI(iGoodROI);
	    disp([  'FILE 2/2: Integrating Sub: ', num2str(iGoodSub), ' / ', num2str(nGoodSub), ...
		' ; ROI: ', num2str(iROI), ' / ', num2str(nRoiAtlas), ' ...'])

	    partFile = [notIntegratedFolder, 'singleSubjectSingleRoiPowerData_iROI', ...
		num2str(iROI), '_iSub', num2str(iSub)];
	    load(partFile)

	    singleSubjectPowerData{iROI} = singleSubjectSingleRoiPowerData;

	end % nGoodRoi loop

	disp(['FILE 2/2: Saving data for subject :', num2str(iGoodSub), ' / ', num2str(nGoodSub), ' ...']);
	subjectDir = [CFG.STAGE_2.outputDataFolder, 'Sub_', num2str(iSub), '/'];
	fileName = [subjectDir, 'singleSubjectPowerData_', num2str(iSub), '.mat'];
	save(fileName, 'singleSubjectPowerData', '-v7.3')

	if(~exist(fileName, 'file'))
	    error('File somehow not saved !')
	end

    end % nGoodSub loop

    if isempty(errorDuringIntegrationException)
	cleanNotIntegratedFolder(notIntegratedFolder);
	disp('Integration DONE !');
    end

catch errorDuringIntegrationException
    warning('Something wrong happened during integration ! not-integrated files will not be clead for safety !');
    fprintf(1,'The identifier was:\n%s', errorDuringIntegrationException.identifier);
    fprintf(1,'There was an error! The message was:\n%s', errorDuringIntegrationException.message);
    disp('Integration finished with errors.');
end % try


%%
