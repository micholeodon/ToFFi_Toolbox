clear; close all; clc;

CFG = [];

%% PARAMETERS TO SET %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tags
CFG.Global.TAG = 'SF_3.0_illustrative_2CPU';
CFG.Global.VERSION = 'YYYY-MM-DD';
CFG.Global.DATE = '2021-08-20-16:19';

stagesToConfigure = [1 2 3 4 5 6 7 8];

%% Global
CFG.Global.rootDir                  = 'C:\johndoe\ToFFi_Toolbox-YYYYMMDD\';
CFG.Global.veryFirstInputDataDir    = 'C:\johndoe\HCP_data\';
CFG.Global.veryFirstInputDataFileNames = { 'data_clean_HCP_att2_' 'flt_LCMV_HCP_att2_' };

CFG.Global.toolsDir                 = './ext_tools/';
CFG.Global.commonDataDir            = './commonData/';

% --- this part shall not be edited! ---
addpath('./globalFunctionsScripts');
CFG.Global.rootDir = fixPath(CFG.Global.rootDir);
CFG.Global.veryFirstInputDataDir = fixPath(CFG.Global.veryFirstInputDataDir);
CFG.Global.toolsDir = fixPath(CFG.Global.toolsDir);
CFG.Global.commonDataDir = fixPath(CFG.Global.commonDataDir);
checkCommonDataPresence(CFG.Global);
% ---------------------------------------

% subjects & roi
CFG.Global.goodSubjects = [1 2 3 4 5 6 7 8 9 10];
CFG.Global.goodROI = [6 25 54 67 70 89 102 105];

% fieldtrip, atlas settings
CFG.Global.fieldtripPath  = 'C:\johndoe\fieldtrip-20210816\';

CFG.Global.atlasType      = 'individual';
CFG.Global.atlasPath      = 'DATA_PREPARATION/PARCELLATIONS_PREP/DK_individual_atlases/output_precomputed/';

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


CFG.Global.sourceModelPath = './commonData/templategrid_HCP_8mm.mat';


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
CFG.Global.maxNumQueuedJobsPerUser = 1;
CFG.Global.maxNumSpmdWorkers = 2;

% --- this part shall not be edited! ---
CFG.Global.maxNumJobsInJobArraySLURM = calculateMaxJobArraySize(CFG.Global);
% ---------------------------------------

%% STAGE_1
STAGE_NAME = 'STAGE_1';

CFG.(STAGE_NAME).MODE  = 'parallel';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix   = 'data_clean_HCP_att2';
CFG.(STAGE_NAME).filterFileNamePrefix = 'flt_LCMV_HCP_att2';

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = 'data';
CFG.(STAGE_NAME).filterVarName        = 'spatialFilter';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021;
% positive integer or 'time'

CFG.(STAGE_NAME).normalizationMethod = 'wholebrain';
% choose: 'wholebrain', 'roiwise', 'none'

CFG.(STAGE_NAME).dummySignalMode = 'no';
% 'no'  - do source projection,
% 'wgn' - put 500 trials of white noise in the sources instead of doing the
%         source projection
% 'wgn-keepTrials' - put white noise in the sources instead of doing the
%                    source projection trial structure and length kept intact

CFG.(STAGE_NAME).frequenciesOfInterest = logspace(0, log10(40), 20);

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

CFG.(STAGE_NAME).MODE  = 'parallel';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).sourcesPowerFileNamePrefix = 'normalizedSourcePower';

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix  = 'normalizedSourcePower';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021;
% positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).trialRejectZ = 2.5; % default 2.5 or inf to reject none

CFG.(STAGE_NAME).doZeroShift = 0; % 1 or 0
CFG.(STAGE_NAME).saveMeanRoiPower = 1; % 1 or 0
% !!! Used in STAGE_7: Individual Classification

CFG.(STAGE_NAME).clusteringMethod = 'kmeans';
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = 'cosine';
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates     = 10;
    % parameter below ignored if numClustersMode == 'fixed'
    CFG.(STAGE_NAME).NumClustEval_distanceMetric  = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization  = 0.012;

CFG.(STAGE_NAME).numClustersMode       = 'optimal'; % 'fixed' or 'optimal'
CFG.(STAGE_NAME).nSpectralModesPerROI  = 10; % ignored if 'optimal' is set

% parameters below ignored if numClustersMode == 'fixed'
CFG.(STAGE_NAME).NumClustEval_kList            = [1 2 3 4 5]; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_nIterations      = 100; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_criterionType   = 'silhouette';
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

CFG.(STAGE_NAME).dataFileNamePrefix   = 'individualFingerprint';

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = 'individualFingerprint';

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

CFG.(STAGE_NAME).MODE  = 'parallel';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).pooledClustersFileNamePrefix = 'pooledClustersInAllROI';

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix  = 'pooledClusters';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).methodName      = 'kmeans'; % possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-clust
CFG.(STAGE_NAME).criterionType   = 'silhouette'; % possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion
CFG.(STAGE_NAME).distanceMetric  = 'cosine'; % possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-Distance
CFG.(STAGE_NAME).kList           = [1 2 3 4 5]; %1:15; % numbers of clusters to test
CFG.(STAGE_NAME).nIterations     = 100; % Should be max. 1000

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

CFG.(STAGE_NAME).MODE  = 'serial';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).pooledClustersFileNamePrefix        = 'pooledClustersInAllROI';
CFG.(STAGE_NAME).clusteringEvaluationFileNamePrefix  = 'clusteringEvaluationAllROI';

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix    = 'pooledClusters';
CFG.(STAGE_NAME).clusteringEvaluationVarNamePrefix  = 'clusteringEvaluationAllROI';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).majoritySubjectsNum = 5; % how many subjects has to contribute to 2nd lvl cluster to be accepted (set N=1 for accepting all clusters)
CFG.(STAGE_NAME).clusteringMethod    = 'kmeans';
CFG.(STAGE_NAME).numberOfClusters    = 'optimal'; % positive integer (fixed for all ROI) or optimal (calculated in S4)
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = 'cosine';
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates    = 10;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization       = 0.012;

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

CFG.(STAGE_NAME).MODE  = 'parallel';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix  = 'pooledClustersInAllROI';

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = 'pooledClusters';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021; % positive integer or 'time'

% CV processing parameters
CFG.(STAGE_NAME).CV.nRepetitions        = 1;
CFG.(STAGE_NAME).CV.nFolds              = 10;
CFG.(STAGE_NAME).CV.save_NLL_Matrices   = 1; % 0 - no, 1 - yes

% modelling parameters
CFG.(STAGE_NAME).nClustersSetting    = 'fixed'; % 'mode' (default), 'optimal', 'fixed';
CFG.(STAGE_NAME).fixed_nClusters     = 1; % if nClustersSetting == 'fixed'
% these should be the same as in STAGE_2 (individual fingerprints) !
CFG.(STAGE_NAME).clusteringMethod = 'kmeans';
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric    = 'cosine';
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates       = 10;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization       = 0.012;
CFG.(STAGE_NAME).majoritySubjectNum = 5;

% path optimal clusters datafile
CFG.(STAGE_NAME).optimalClustersDataFile = '../../STAGE_4/output/clusteringEvaluationAllROI.mat';
CFG.(STAGE_NAME).optimalClustersVarName = 'clusteringEvaluationAllROI';

% --- this part shall not be edited! ---
CFG.(STAGE_NAME).dataNamesList = { ...
			    CFG.(STAGE_NAME).dataFileNamePrefix, ...
			    };

CFG.(STAGE_NAME).inputDataFolder{1} = [CFG.Global.rootDir, 'STAGE_3/output/']; % Individual Fingerprints
CFG.(STAGE_NAME).outputDataFolder = [CFG.Global.rootDir, STAGE_NAME, '/output/'];
% ---------------------------------------

%% STAGE_7
STAGE_NAME = 'STAGE_7';

CFG.(STAGE_NAME).MODE  = 'parallel';
% 'serial' or 'parallel'

CFG.(STAGE_NAME).dataFileNamePrefix  = 'singleSubjectPowerData';

% variables names to check
CFG.(STAGE_NAME).dataVarNamePrefix    = 'singleSubjectPowerData';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021; % positive integer or 'time'

% CV processing parameters
CFG.(STAGE_NAME).CV.nRepetitions        = 1;
CFG.(STAGE_NAME).CV.nFolds              = 5;

% modelling parameters
CFG.(STAGE_NAME).nClustersSetting  = 'optimal'; % 'optimal' (default), 'fixed';
CFG.(STAGE_NAME).fixed_nClusters   = 4; % if nClustersSetting == 'fixed'
% these should be the same as in STAGE_2 (individual fingerprints) !
CFG.(STAGE_NAME).clusteringMethod = 'kmeans';
if(~isempty(CFG.(STAGE_NAME).clusteringMethod))
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric = 'cosine';
    CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).nReplicates    = 10;
    % parameter below ignored if numClustersMode == 'fixed'
    CFG.(STAGE_NAME).NumClustEval_distanceMetric = CFG.(STAGE_NAME).clustering.(CFG.(STAGE_NAME).clusteringMethod).distanceMetric;
end
CFG.(STAGE_NAME).gaussianMixtureRegularization  = 0.012;
% parameters below ignored if numClustersMode == 'fixed'
CFG.(STAGE_NAME).NumClustEval_kList            = [1 2 3 4 5]; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_nIterations      = 100; % ignored if 'fixed' is set
CFG.(STAGE_NAME).NumClustEval_criterionType   = 'silhouette'; % possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion

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

CFG.(STAGE_NAME).MODE  = 'serial';
% 'serial' or 'parallel'

% used in last line: CFG.(STAGE_NAME).dataNamesList = { ...
CFG.(STAGE_NAME).pooledClustersFileNamePrefix        = 'pooledClustersInAllROI';
CFG.(STAGE_NAME).spectralFingerprintsFileNamePrefix   = 'singleRoiSpectralFingerprint_iROI';

% variables names to check
CFG.(STAGE_NAME).pooledClustersVarNamePrefix        = 'pooledClusters';
CFG.(STAGE_NAME).spectralFingerprintsVarNamePrefix   = 'singleRoiSpectralFingerprint';

% RNG setting
CFG.(STAGE_NAME).rngSeed = 2021; % positive integer or 'time'

% Parameters for calculation
CFG.(STAGE_NAME).linkageMethod         = 'average';    % select one from: https://www.mathworks.com/help/stats/linkage.html
CFG.(STAGE_NAME).linkageDistanceMetric = 'cosine'; % select one from: https://www.mathworks.com/help/stats/linkage.html
CFG.(STAGE_NAME).nSimilarityClusters   = 4; % P parameter from : https://www.mathworks.com/help/stats/dendrogram.html

% majority spectral modes
CFG.(STAGE_NAME).majoritySubjectsNum   = 5; % how many subjects has to contribute to 2nd lvl cluster to be accepted (set N=1 for accepting all clusters)

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
