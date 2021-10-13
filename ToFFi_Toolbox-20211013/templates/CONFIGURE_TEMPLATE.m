clear; close all; clc;

CFG = [];

%% PARAMETERS TO SET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tags
CFG.Global.TAG = __TAG__;
CFG.Global.VERSION = __VERSION__;
CFG.Global.DATE = __DATE__;

stagesToConfigure = __stagesToConfigure__;

%% Global
CFG.Global.rootDir                  = __G_rootDir__;
CFG.Global.veryFirstInputDataDir    = __G_veryFirstInputDataDir__;
CFG.Global.veryFirstInputDataFileNames = __G_veryFirstInputDataFileNames__;

CFG.Global.toolsDir                 = __G_toolsDir__;
CFG.Global.commonDataDir            = __G_commonDataDir__;

% --- this part shall not be edited! ---
addpath('./globalFunctionsScripts');
CFG.Global.rootDir = fixPath(CFG.Global.rootDir);
CFG.Global.veryFirstInputDataDir = fixPath(CFG.Global.veryFirstInputDataDir);
CFG.Global.toolsDir = fixPath(CFG.Global.toolsDir);
CFG.Global.commonDataDir = fixPath(CFG.Global.commonDataDir);
checkCommonDataPresence(CFG.Global);
% ---------------------------------------

% subjects & roi
CFG.Global.goodSubjects = __G_goodSubjects__;
CFG.Global.goodROI = __G_goodROI__;

% fieldtrip, atlas settings
CFG.Global.fieldtripPath  = __G_fieldtripPath__;

CFG.Global.atlasType      = __G_atlasType__;
CFG.Global.atlasPath      = __G_atlasPath__;

% --- this part shall not be edited! ---
CFG.Global.atlasPath = fixPath(CFG.Global.atlasPath);
CFG.Global.fieldtripPath = fixPath(CFG.Global.fieldtripPath);
addpath(CFG.Global.fieldtripPath)
if(~exist(CFG.Global.fieldtripPath, 'dir'))
    error('ERROR! Provided Fieldtrip directory not exist!');
end
if(~exist([CFG.Global.fieldtripPath, 'ft_defaults.m'], 'file'))
    error(['ERROR! Provided Fieldtrip directory is corrupted (ft_defaults.m ' ...
           'not exist)!']);
end
ft_defaults
% ---------------------------------------


CFG.Global.sourceModelPath = __G_sourceModelPath__;


% --- this part shall not be edited! ---
CFG.Global.sourceModelPath = fixPath(CFG.Global.sourceModelPath);
CFG.Global.sourceAtlasAndSourceModel.sourceModel = ...
    prepareSourceModel(CFG.Global.sourceModelPath);
[CFG.Global.sourceAtlasAndSourceModel.sourceAtlas, roiValidForAllSubjects] = ...
    prepareAtlas(CFG.Global, CFG.Global.sourceAtlasAndSourceModel.sourceModel);
CFG.Global.sourceAtlasAndSourceModel.areNonRoiVoxelPresent = ...
    checkNonRoiVoxelsPresence(CFG.Global.sourceAtlasAndSourceModel);
% individual atlases can change goodRoi list
if(~all(ismember(CFG.Global.goodROI, roiValidForAllSubjects)))
    CFG.Global.goodROI = intersect(CFG.Global.goodROI, roiValidForAllSubjects);
    CFG.Global.goodRoiChanged = 1; % only possible when using individual
                                   % atlases
    warning('WARNING! goodROI list changed due to individual atlas characteristics!')
else
    CFG.Global.goodRoiChanged = 0; % default when using group atlases
end
% ---------------------------------------


% parallel comp. settings (bother only when doing parallel comp.)
% NOTE !
% Changing number of jobs, batches or workers  will change
% the results despite fixed rng seed, because more/less random
% seeds will be generated for each job and each batch and worker.
CFG.Global.maxNumQueuedJobsPerUser = __G_maxNumQueuedJobsPerUser__;
CFG.Global.maxNumSpmdWorkers = __G_maxNumSpmdWorkers__;

% --- this part shall not be edited! ---
CFG.Global.maxNumJobsInJobArraySLURM = calculateMaxJobArraySize(CFG.Global);
% ---------------------------------------

%% STAGE_1
STAGE_NAME = 'STAGE_1';

CFG.(STAGE_NAME).MODE  = __S1_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix   = __S1_dataFileNamePrefix__;
CFG.(STAGE_NAME).filterFileNamePrefix = __S1_filterFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = __S1_dataVarNamePrefix__;
CFG.(STAGE_NAME).filterVarName        = __S1_filterVarName__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S1_rngSeed__;
% positive integer or 'time'

CFG.(STAGE_NAME).normalizationMethod = __S1_normalizationMethod__;
% choose: 'wholebrain', 'roiwise', 'none'

CFG.(STAGE_NAME).dummySignalMode = __S1_dummySignalMode__;
% 'no'  - do source projection,
% 'wgn' - put 500 trials of white noise in the sources instead of doing the
%         source projection
% 'wgn-keepTrials' - put white noise in the sources instead of doing the
%                    source projection trial structure and length kept intact

CFG.(STAGE_NAME).frequenciesOfInterest = __S1_frequenciesOfInterest__;

% --- this part shall not be edited! ---
CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.veryFirstInputDataDir];
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).dataFileNamePrefix, ...
			    CFG.(STAGE_NAME).filterFileNamePrefix ...
			    };
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_2
STAGE_NAME = 'STAGE_2';

CFG.(STAGE_NAME).MODE  = __S2_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).sourcesPowerFileNamePrefix = __S2_sourcesPowerFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix  = __S2_dataVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S2_rngSeed__;
% positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).trialRejectZ = __S2_trialRejectZ__; % default 2.5 or inf to reject none

CFG.(STAGE_NAME).doZeroShift = __S2_doZeroShift__; % 1 or 0
CFG.(STAGE_NAME).saveMeanRoiPower = __S2_saveMeanRoiPower__; % 1 or 0
% !!! Used in STAGE_7: Individual Classification

CFG.(STAGE_NAME).clusteringMethod = __S2_clusteringMethod__;
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = __S2_distanceMetric__;
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates     = __S2_nReplicates__;
    % parameter below ignored if numClustersMode == 'fixed'
    CFG.(STAGE_NAME).NumClustEval_distanceMetric  = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization  = __S2_gaussianMixtureRegularization__;

CFG.(STAGE_NAME).numClustersMode       = __S2_numClustersMode__; % 'fixed' or 'optimal'
CFG.(STAGE_NAME).nSpectralModesPerROI  = __S2_nSpectralModesPerROI__; % ignored if 'optimal' is set

% parameters below ignored if numClustersMode == 'fixed'
CFG.(STAGE_NAME).NumClustEval_kList            = __S2_NumClustEval_kList__; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_nIterations      = __S2_NumClustEval_nIterations__; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_criterionType   = __S2_NumClustEval_criterionType__;
% possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion

% make clustering evaluation coherent with clustering method
% --- this part shall not be edited! ---
CFG.(STAGE_NAME).NumClustEval_methodName      = CFG.(STAGE_NAME).clusteringMethod; % possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-clust

% used to load all data files of the subject
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).sourcesPowerFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_1/output/'];
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_3
STAGE_NAME = 'STAGE_3';

CFG.(STAGE_NAME).dataFileNamePrefix   = __S3_dataFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = __S3_dataVarNamePrefix__;

% used to load all data files of the subject
% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).dataFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_2/output/'];
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_4
STAGE_NAME = 'STAGE_4';

CFG.(STAGE_NAME).MODE  = __S4_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).pooledClustersFileNamePrefix = __S4_pooledClustersFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix  = __S4_pooledClustersVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S4_rngSeed__; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).methodName      = __S4_methodName__; % possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-clust
CFG.(STAGE_NAME).criterionType   = __S4_criterionType__; % possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion
CFG.(STAGE_NAME).distanceMetric  = __S4_distanceMetric__; % possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-Distance
CFG.(STAGE_NAME).kList           = __S4_kList__; %1:15; % numbers of clusters to test
CFG.(STAGE_NAME).nIterations     = __S4_nIterations__; % Should be max. 1000

% used to load all data files of the subject
% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).pooledClustersFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_3/output/'];
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_5
STAGE_NAME = 'STAGE_5';

CFG.(STAGE_NAME).MODE  = __S5_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).pooledClustersFileNamePrefix        = __S5_pooledClustersFileNamePrefix__;
CFG.(STAGE_NAME).clusteringEvaluationFileNamePrefix  = __S5_clusteringEvaluationFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix    = __S5_pooledClustersVarNamePrefix__;
CFG.(STAGE_NAME).clusteringEvaluationVarNamePrefix  = __S5_clusteringEvaluationVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S5_rngSeed__; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).majoritySubjectsNum = __S5_majoritySubjectsNum__; % how many subjects has to contribute to 2nd lvl cluster to be accepted (set N=1 for accepting all clusters)
CFG.(STAGE_NAME).clusteringMethod    = __S5_clusteringMethod__;
CFG.(STAGE_NAME).numberOfClusters    = __S5_numberOfClusters__; % positive integer (fixed for all ROI) or optimal (calculated in S4)
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = __S5_distanceMetric__;
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates    = __S5_nReplicates__;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization       = __S5_gaussianMixtureRegularization__;

% used to load all data files of the subject
% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).pooledClustersFileNamePrefix, ...
			    CFG.(STAGE_NAME).clusteringEvaluationFileNamePrefix
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_3/output/'];
CFG.(STAGE_NAME).inputDataFolder{2} = [CFG.Global.rootDir, 'STAGE_4/output/'];
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_6
STAGE_NAME = 'STAGE_6';

CFG.(STAGE_NAME).MODE  = __S6_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix  = __S6_dataFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = __S6_dataVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S6_rngSeed__; % positive integer or 'time'

% CV processing parameters
CFG.(STAGE_NAME).CV.nRepetitions        = __S6_nRepetitions__;
CFG.(STAGE_NAME).CV.nFolds              = __S6_nFolds__;
CFG.(STAGE_NAME).CV.save_NLL_Matrices   = __S6_save_NLL_Matrices__; % 0 - no, 1 - yes

% modelling parameters
CFG.(STAGE_NAME).nClustersSetting    = __S6_nClustersSetting__; % 'mode' (default), 'optimal', 'fixed';
CFG.(STAGE_NAME).fixed_nClusters     = __S6_fixed_nClusters__; % if nClustersSetting == 'fixed'
% these should be the same as in STAGE_2 (individual fingerprints) !
CFG.(STAGE_NAME).clusteringMethod = __S6_clusteringMethod__;
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric    = __S6_distanceMetric__;
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates       = __S6_nReplicates__;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization       = __S6_gaussianMixtureRegularization__;
CFG.(STAGE_NAME).majoritySubjectNum = __S6_majoritySubjectNum__;

% path optimal clusters datafile
CFG.(STAGE_NAME).optimalClustersDataFile = __S6_optimalClustersDataFile__;
CFG.(STAGE_NAME).optimalClustersVarName = __S6_optimalClustersVarName__;

% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).dataFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_3/output/']; % Individual Fingerprints
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_7
STAGE_NAME = 'STAGE_7';

CFG.(STAGE_NAME).MODE  = __S7_MODE__;
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix  = __S7_dataFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = __S7_dataVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S7_rngSeed__; % positive integer or 'time'

% CV processing parameters
CFG.(STAGE_NAME).CV.nRepetitions        = __S7_nRepetitions__;
CFG.(STAGE_NAME).CV.nFolds              = __S7_nFolds__;

% modelling parameters
CFG.(STAGE_NAME).nClustersSetting  = __S7_nClustersSetting__; % 'optimal' (default), 'fixed';
CFG.(STAGE_NAME).fixed_nClusters   = __S7_fixed_nClusters__; % if nClustersSetting == 'fixed'
% these should be the same as in STAGE_2 (individual fingerprints) !
CFG.(STAGE_NAME).clusteringMethod = __S7_clusteringMethod__;
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = __S7_distanceMetric__;
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates    = __S7_nReplicates__;
    % parameter below ignored if numClustersMode == 'fixed'
    CFG.(STAGE_NAME).NumClustEval_distanceMetric = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization  = __S7_gaussianMixtureRegularization__;
% parameters below ignored if numClustersMode == 'fixed'
CFG.(STAGE_NAME).NumClustEval_kList            = __S7_NumClustEval_kList__; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_nIterations      = __S7_NumClustEval_nIterations__; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_criterionType   = __S7_NumClustEval_criterionType__; % possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion

% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).dataFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).NumClustEval_methodName = CFG.(STAGE_NAME).clusteringMethod;

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_2/output/']; % single ROI single Subject Roi power data
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_8
STAGE_NAME = 'STAGE_8';

CFG.(STAGE_NAME).MODE  = __S8_MODE__;
% 'serial' or 'parallel'

% used in last line: CFG.(STAGE_NAME).dataNamesList = { ...
CFG.(STAGE_NAME).pooledClustersFileNamePrefix        = __S8_pooledClustersFileNamePrefix__;
CFG.(STAGE_NAME).spectralFingerprintsFileNamePrefix   = __S8_spectralFingerprintsFileNamePrefix__;

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix        = __S8_pooledClustersVarNamePrefix__;
CFG.(STAGE_NAME).spectralFingerprintsVarNamePrefix   = __S8_spectralFingerprintsVarNamePrefix__;

% RNG setting
CFG.(STAGE_NAME).rngSeed = __S8_rngSeed__; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).linkageMethod         = __S8_linkageMethod__;    % select one from: https://www.mathworks.com/help/stats/linkage.html
CFG.(STAGE_NAME).linkageDistanceMetric = __S8_linkageDistanceMetric__; % select one from: https://www.mathworks.com/help/stats/linkage.html
CFG.(STAGE_NAME).nSimilarityClusters   = __S8_nSimilarityClusters__; % P parameter from : https://www.mathworks.com/help/stats/dendrogram.html

% majority spectral modes
CFG.(STAGE_NAME).majoritySubjectsNum   = __S8_majoritySubjectsNum__; % how many subjects has to contribute to 2nd lvl cluster to be accepted (set N=1 for accepting all clusters)

% used to load all data files of the subject
% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
				CFG.(STAGE_NAME).pooledClustersFileNamePrefix, ...
				CFG.(STAGE_NAME).spectralFingerprintsFileNamePrefix, ...
			    };

% !!! CAREFUL !!! Order matters !
%  - CFG.(STAGE_NAME).inputDataFolder{1} is a path to pooled clusters !
%  - CFG.(STAGE_NAME).inputDataFolder{2} is a path to spectral fingerprints !

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_3/output/']; % pooledClusters
CFG.(STAGE_NAME).inputDataFolder{2} = [CFG.Global.rootDir, 'STAGE_5/output/']; % Spectral Fingerprints
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------


%% PRODUCE CFG.mat files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% Do not edit ! %%% %

% fix paths

STAGE_NAMES = {'STAGE_1', 'STAGE_2', 'STAGE_3', 'STAGE_4', ...
	       'STAGE_5', 'STAGE_6', 'STAGE_7', 'STAGE_8' };

for iStage = 1:numel(STAGE_NAMES)
    CFG.(STAGE_NAMES{iStage}).inputDataFolder{1} = fixPath(CFG.(STAGE_NAMES{iStage}).inputDataFolder{1});
    CFG.(STAGE_NAMES{iStage}).outputDataFolder = fixPath(CFG.(STAGE_NAMES{iStage}).outputDataFolder);
end
CFG.(STAGE_NAMES{5}).inputDataFolder{2} = fixPath(CFG.(STAGE_NAMES{5}).inputDataFolder{2});
CFG.(STAGE_NAMES{8}).inputDataFolder{2} = fixPath(CFG.(STAGE_NAMES{8}).inputDataFolder{2});


STAGE_NAMES(stagesToConfigure)

disp('Generating output directories ...')
% generate output directories in stages if not exist
for STAGE_NAME = STAGE_NAMES(stagesToConfigure)
    STAGE_NAME = STAGE_NAME{1};
    if(~exist(CFG.(STAGE_NAME).outputDataFolder, 'dir'))
	disp([STAGE_NAME, ':Output directory missing - creating !'])
	mkdir(CFG.(STAGE_NAME).outputDataFolder)
    end
end
disp('Generating output directories DONE')

% Generate directories for subjects inside STAGE_1/output and STAGE_2/output
if(ismember(1, stagesToConfigure))
    disp('Generating output directories for subjects ...')
    for iSub = CFG.Global.goodSubjects
	mkdir([CFG.(STAGE_NAMES{1}).outputDataFolder, 'Sub_', num2str(iSub)])
    end
    disp('Generating output directories for subjects DONE')
end

if(ismember(2, stagesToConfigure))
    disp('Generating output directories for subjects ...')
    for iSub = CFG.Global.goodSubjects
	mkdir([CFG.(STAGE_NAMES{2}).outputDataFolder, 'Sub_', num2str(iSub)])
    end
    disp('Generating output directories for subjects DONE')
end


% Routines below will put CFG.mat files inside STAGE_X/output/ directories.
CFG_copy = CFG;
disp('Putting CFG.mat files in place ...')
for STAGE_NAME = STAGE_NAMES(stagesToConfigure)
    STAGE_NAME = STAGE_NAME{1};
    CFG = [];
    CFG.Global = CFG_copy.Global;
    CFG.(STAGE_NAME) = CFG_copy.(STAGE_NAME);
    save([CFG.(STAGE_NAME).outputDataFolder, '/CFG.mat'], 'CFG')
end
disp('Putting CFG.mat files in place DONE')

disp('CONFIGURATION DONE!')
