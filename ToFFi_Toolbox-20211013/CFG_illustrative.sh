#!/bin/bash

################################################################################
# USER FILLS THIS SECTION ######################################################
################################################################################

VERSION=YYYY-MM-DD
TAG=SF_3.0_illustrative_2CPU
DATE=`date +'%Y-%m-%d-%H:%M'`
MATLAB_RUNPATH='/usr/local/bin/matlab'
IS_LINUX=0; # =1 if you ar running Linux or =0 if other system

### CLEANUP ###
rm_output_in_stages=(1 2 3 4 5 6 7 8)
rm_logs=1;

### STAGES TO CONFIGURE ###
stages=(1 2 3 4 5 6 7 8)

### GLOBAL PARAMETERS ###
G_rootDir='C:\johndoe\ToFFi_Toolbox-YYYYMMDD\' # absolute path !
G_veryFirstInputDataDir='C:\johndoe\HCP_data\' # absolute path !

G_veryFirstInputDataFileNames=('data_clean_HCP_att2_' 'flt_LCMV_HCP_att2_')
# Syntax:  =('a_' 'b_') . Note apostrophes and the ending underscores _ ! (subject number will follow after it)

G_toolsDir='./ext_tools/'
G_commonDataDir='./commonData/'

# fieldtrip, atlas settings
G_fieldtripPath='C:\johndoe\fieldtrip-20210816\' # absolute path !
G_atlasType='individual'
G_atlasPath='DATA_PREPARATION/PARCELLATIONS_PREP/DK_individual_atlases/output_precomputed/'
G_sourceModelPath=$G_commonDataDir'templategrid_HCP_8mm.mat'

# subjects & roi
G_goodSubjects=(`seq 1 10`)
G_goodROI=(6 25 54 67 70 89 102 105)

# parallel cluster settings
G_maxNumQueuedJobsPerUser=1
G_maxNumSpmdWorkers=2


### STAGE 1 ###
S1_MODE='parallel' # 'serial' or 'parallel'

S1_dataFileNamePrefix='data_clean_HCP_att2'
S1_filterFileNamePrefix='flt_LCMV_HCP_att2'

# variables names to check
S1_dataVarNamePrefix='data'
S1_filterVarName='spatialFilter'

# RNG setting
S1_rngSeed=2021
# positive integer or 'time'

S1_normalizationMethod='wholebrain'
# choose: 'wholebrain', 'roiwise', 'none'

S1_dummySignalMode='no'
# 'no'  - do source projection, 
# 'wgn' - put 500 trials of white noise in the sources instead of doing the 
#         source projection
# 'wgn-keepTrials' - put white noise in the sources instead of doing the
#                    source projection trial structure and length kept intact

S1_frequenciesOfInterest='logspace(0, log10(40), 20)'
# Two syntaxes possible: (1 4 6 10 15 30)
# or
# 'matlab_function(...)', e.g. 'logspace(0, log10(120), 50)'

# SLURM options
S1_SLURM_jobName='H1_S1'
S1_SLURM_queueName='serial'
S1_SLURM_nTasksPerNode=24
S1_SLURM_mem=250000
S1_SLURM_time='01:00:00'
S1_SLURM_mailType='ALL'
S1_SLURM_array='1-1'
S1_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'


### STAGE 2 ###
S2_MODE='parallel' # 'serial' or 'parallel'

# variables names to check
S2_sourcesPowerFileNamePrefix='normalizedSourcePower';
S2_dataVarNamePrefix='normalizedSourcePower';

# RNG setting
S2_rngSeed=2021; # positive integer or 'time'

# Parameters for calculation
S2_trialRejectZ=2.5; # default 2.5 or inf to reject none
S2_doZeroShift=0; # 1 or 0
S2_saveMeanRoiPower=1; # 1 or 0 ; !!! Used in STAGE_7: Individual Classification

# clustering
S2_clusteringMethod='kmeans';
S2_distanceMetric='cosine'; # possible options https://www.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans&s_tid=srchtitle#buefs04-Distance
S2_nReplicates=10;
S2_gaussianMixtureRegularization=0.012;
S2_numClustersMode='optimal'; # 'fixed' or 'optimal'
S2_nSpectralModesPerROI=10; # ignored if 'optimal' is set
# parameters below ignored if numClustersMode == 'fixed' 
S2_NumClustEval_kList=(`seq 1 5`); # ignored if 'fixed' is set
S2_NumClustEval_nIterations=100 # ignored if 'fixed' is set
S2_NumClustEval_criterionType='silhouette'; # possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion

# SLURM options for STAGE_2/RUN.m script
S2_SLURM_jobName='H1_S2'
S2_SLURM_queueName='serial'
S2_SLURM_nTasksPerNode=24
S2_SLURM_mem=250000
S2_SLURM_time='01:00:00' # '15:00:00'
S2_SLURM_mailType='ALL'
S2_SLURM_array='1-1'
S2_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'
# SLURM options for STAGE_2/INTEGRATE.m script
S2INT_SLURM_jobName='H1_S2INT'
S2INT_SLURM_queueName='serial'
S2INT_SLURM_nTasksPerNode=24
S2INT_SLURM_mem=64000
S2INT_SLURM_time='00:10:00'
S2INT_SLURM_mailType='ALL'


### STAGE 3 ###
S3_dataFileNamePrefix='individualFingerprint';

# variables names to check
S3_dataVarNamePrefix='individualFingerprint';

# SLURM options
S3_SLURM_jobName='H1_S3'
S3_SLURM_queueName='serial'
S3_SLURM_nTasksPerNode=24
S3_SLURM_mem=16000
S3_SLURM_time='00:10:00'
S3_SLURM_mailType='ALL'


### STAGE 4 ###
S4_MODE='parallel' # 'serial' or 'parallel'

S4_pooledClustersFileNamePrefix='pooledClustersInAllROI';

# variables names to check
S4_pooledClustersVarNamePrefix='pooledClusters';

# RNG setting
S4_rngSeed=2021;  # positive integer or 'time'

# Parameters for calculation
S4_methodName='kmeans';  # possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-clust
S4_criterionType='silhouette';  # possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion
S4_distanceMetric='cosine';  # possible options https://www.mathworks.com/help/stats/evalclusters.html#bt0oocm_sep_shared-Distance
S4_kList=(`seq 1 5`);  # numbers of clusters to test
S4_nIterations=100;  

# SLURM options for STAGE_4/RUN.m script
S4_SLURM_jobName='H1_S4'
S4_SLURM_queueName='serial'
S4_SLURM_nTasksPerNode=24
S4_SLURM_mem=128000
S4_SLURM_time='00:30:00' #'01:00:00'
S4_SLURM_mailType='ALL'
S4_SLURM_array='1-1'
S4_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'
# SLURM options for STAGE_4/INTEGRATE.m script
S4INT_SLURM_jobName='H1_S4INT'
S4INT_SLURM_queueName='serial'
S4INT_SLURM_nTasksPerNode=24
S4INT_SLURM_mem=64000
S4INT_SLURM_time='00:10:00'
S4INT_SLURM_mailType='ALL'

### STAGE 5 ###
S5_MODE='serial' # 'serial' or 'parallel'

S5_pooledClustersFileNamePrefix='pooledClustersInAllROI';
S5_clusteringEvaluationFileNamePrefix='clusteringEvaluationAllROI';

# variables names to check
S5_pooledClustersVarNamePrefix='pooledClusters';
S5_clusteringEvaluationVarNamePrefix='clusteringEvaluationAllROI';

# RNG setting
S5_rngSeed=2021; # positive integer or 'time'

# Parameters for calculation
S5_majoritySubjectsNum=5; # how many subjects has to contribute to 2nd lvl cluster to be accepted (set =1 for accepting all clusters)
S5_clusteringMethod='kmeans';
S5_numberOfClusters='optimal'; # positive integer (fixed for all ROI) or optimal (calculated in S4)
S5_distanceMetric='cosine'; # possible options https://www.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans&s_tid=srchtitle#buefs04-Distance
S5_nReplicates=10;
S5_gaussianMixtureRegularization=0.012;    

# SLURM options 
S5_SLURM_jobName='H1_S5'
S5_SLURM_queueName='serial'
S5_SLURM_nTasksPerNode=24
S5_SLURM_mem=128000
S5_SLURM_time='00:30:00'
S5_SLURM_mailType='ALL'
S5_SLURM_array='1-1'
S5_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'



### STAGE 6 ###
S6_MODE='parallel' # 'serial' or 'parallel'

S6_dataFileNamePrefix='pooledClustersInAllROI';

# variables names to check
S6_dataVarNamePrefix='pooledClusters';

# RNG setting
S6_rngSeed=2021; # positive integer or 'time'

# CV processing parameters 
S6_nRepetitions=1; 
S6_nFolds=10;
S6_save_NLL_Matrices=1; # 0 - no, 1 - yes

# modelling parameters
S6_nClustersSetting='fixed'; # 'mode' (default), 'optimal', 'fixed';
S6_fixed_nClusters=1; # if nClustersSetting == 'fixed'
# these should be the same as in STAGE_2 (individual fingerprints) !
S6_clusteringMethod='kmeans';
S6_distanceMetric='cosine'; # possible options https://www.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans&s_tid=srchtitle#buefs04-Distance
S6_nReplicates=10;
S6_gaussianMixtureRegularization=0.012;
S6_majoritySubjectNum=5; # how many subjects has to contribute to 2nd lvl cluster to be accepted (set =1 for accepting all clusters)

# path optimal clusters datafile
S6_optimalClustersDataFile='../../STAGE_4/output/clusteringEvaluationAllROI.mat';
S6_optimalClustersVarName='clusteringEvaluationAllROI';

# SLURM options for STAGE_5/RUN.m script
S6_SLURM_jobName='H1_S6'
S6_SLURM_queueName='serial'
S6_SLURM_nTasksPerNode=24
S6_SLURM_mem=128000
S6_SLURM_time='01:00:00' #'01:00:00'
S6_SLURM_mailType='ALL'
S6_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'

# SLURM options for STAGE_6/INTEGRATE.m script
S6INT_SLURM_jobName='H1_S6INT'
S6INT_SLURM_queueName='serial'
S6INT_SLURM_nTasksPerNode=24
S6INT_SLURM_mem=6400
S6INT_SLURM_time='00:10:00'
S6INT_SLURM_mailType='ALL'


### STAGE 7 ###
S7_MODE='parallel' # 'serial' or 'parallel'

S7_dataFileNamePrefix='singleSubjectPowerData';

# variables names to check
S7_dataVarNamePrefix='singleSubjectPowerData';

# RNG setting
S7_rngSeed=2021; # positive integer or 'time'

# CV processing parameters 
S7_nRepetitions=1 
S7_nFolds=5;

# modelling parameters
S7_nClustersSetting='optimal'; # 'optimal' (default), 'fixed';
S7_fixed_nClusters=4; # if nClustersSetting == 'fixed'
# these should be the same as in STAGE_2 (individual fingerprints) !
S7_clusteringMethod='kmeans';
S7_distanceMetric='cosine'; # possible options https://www.mathworks.com/help/stats/kmeans.html?searchHighlight=kmeans&s_tid=srchtitle#buefs04-Distance
S7_nReplicates=10;
S7_gaussianMixtureRegularization=0.012;
# parameters below ignored if numClustersMode == 'fixed' 
S7_NumClustEval_kList=(`seq 1 5`); # ignored if 'fixed' is set
S7_NumClustEval_nIterations=100; # ignored if 'fixed' is set
S7_NumClustEval_criterionType='silhouette'; # possible options https://www.mathworks.com/help/stats/evalclusters.html#shared-criterion

# SLURM options
S7_SLURM_jobName='H1_S7'
S7_SLURM_queueName='serial'
S7_SLURM_nTasksPerNode=24
S7_SLURM_mem=128000
S7_SLURM_time='02:00:00'
S7_SLURM_mailType='ALL'
S7_SLURM_array='1-1'
S7_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'


### STAGE 8 ###
S8_MODE='serial' # 'serial' or 'parallel'

S8_pooledClustersFileNamePrefix='pooledClustersInAllROI';
S8_spectralFingerprintsFileNamePrefix='singleRoiSpectralFingerprint_iROI';

# variables names to check
S8_pooledClustersVarNamePrefix='pooledClusters';
S8_spectralFingerprintsVarNamePrefix='singleRoiSpectralFingerprint';

# RNG setting
S8_rngSeed=2021; # positive integer or 'time'

# Parameters for calculation
S8_linkageMethod='average';    # select one from: https://www.mathworks.com/help/stats/linkage.html
S8_linkageDistanceMetric='cosine';     # select one from: https://www.mathworks.com/help/stats/linkage.html
S8_nSimilarityClusters=4;           # P parameter from : https://www.mathworks.com/help/stats/dendrogram.html

# majority spectral modes
S8_majoritySubjectsNum=5; # how many subjects has to contribute to 2nd lvl cluster to be accepted (set to 1 for accepting all clusters)

# SLURM options
S8_SLURM_jobName='H1_S8'
S8_SLURM_queueName='serial'
S8_SLURM_nTasksPerNode=24
S8_SLURM_mem=12800
S8_SLURM_time='00:30:00'
S8_SLURM_mailType='ALL'
S8_SLURM_array='1-1'
S8_SLURM_licence='matlab_dct@licencje.task.gda.pl:1'

################################################################################
################################################################################
################################################################################

# MAIN (DO NOT EDIT) ###########################################################

# do selected cleanup procedures
[ ${#rm_output_in_stages[@]} -gt 0 ] && . rm_output_data.sh "${rm_output_in_stages[@]/#/}"
[ $rm_logs -eq 1 ] && . rm_logs_autosaves.sh 

# copy template into new CFG matlab script
cp -r templates/CONFIGURE_TEMPLATE.m ./CONFIGURE.m

# fill values for Tags
echo "Filling configuration tag ..."
sed -i "s+__TAG__+'$TAG'+g" "./CONFIGURE.m"
sed -i "s+__VERSION__+'$VERSION'+g" "./CONFIGURE.m"
sed -i "s+__DATE__+\'$DATE\'+g" "./CONFIGURE.m"
# misc
echo "Checking which stages to configure ..."
sed -i  "s+__stagesToConfigure__+`echo \[${stages[@]}\]`+g" "./CONFIGURE.m"

# fill values for Global cfg
echo "Filling global configuration ..."
sed -i  "s+__G_rootDir__+'${G_rootDir}'+g" "./CONFIGURE.m"
sed -i  "s+__G_veryFirstInputDataDir__+'${G_veryFirstInputDataDir}'+g" "./CONFIGURE.m"

fileList='' # init empty
for file in "${G_veryFirstInputDataFileNames[@]}"
do
	fileList=`echo "${fileList[*]}" \'${file}\'`
done
sed -i  "s+__G_veryFirstInputDataFileNames__+`echo \{ ${fileList} \}`+g" "./CONFIGURE.m"

sed -i  "s+__G_toolsDir__+'${G_toolsDir}'+g" "./CONFIGURE.m"
sed -i  "s+__G_commonDataDir__+'${G_commonDataDir}'+g" "./CONFIGURE.m"
sed -i  "s+__G_fieldtripPath__+'${G_fieldtripPath}'+g" "./CONFIGURE.m"
sed -i  "s+__G_atlasType__+'${G_atlasType}'+g" "./CONFIGURE.m"
sed -i  "s+__G_atlasPath__+'${G_atlasPath}'+g" "./CONFIGURE.m"
sed -i  "s+__G_sourceModelPath__+'${G_sourceModelPath}'+g" "./CONFIGURE.m"
sed -i  "s+__G_goodSubjects__+`echo \[${G_goodSubjects[@]}\]`+g" "./CONFIGURE.m"
sed -i  "s+__G_goodROI__+`echo \[${G_goodROI[@]}\]`+g" "./CONFIGURE.m"
sed -i  "s+__G_maxNumQueuedJobsPerUser__+${G_maxNumQueuedJobsPerUser}+g" "./CONFIGURE.m"
sed -i  "s+__G_maxNumSpmdWorkers__+${G_maxNumSpmdWorkers}+g" "./CONFIGURE.m"

# configure for stages defined in $stages variable
for iStage in "${stages[@]}"
do
	echo "Filling configuration for STAGE $iStage ..."
	case "$iStage" in
		1)
			# fill values for Stage 1
			sed -i  "s+__S1_MODE__+'${S1_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S1_dataFileNamePrefix__+'${S1_dataFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S1_filterFileNamePrefix__+'${S1_filterFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S1_dataVarNamePrefix__+'${S1_dataVarNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S1_filterVarName__+'${S1_filterVarName}'+g" "./CONFIGURE.m"
			if [ $S1_rngSeed = 'time' ]
			then
				sed -i  "s+__S1_rngSeed__+'${S1_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S1_rngSeed__+${S1_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S1_normalizationMethod__+'${S1_normalizationMethod}'+g" "./CONFIGURE.m"
			sed -i  "s+__S1_dummySignalMode__+'${S1_dummySignalMode}'+g" "./CONFIGURE.m"

			if [ "${#S1_frequenciesOfInterest[@]}" -gt 1 ] # syntax to allow arrays and linspace, logspace
			then
				sed -i  "s+__S1_frequenciesOfInterest__+`echo \[${S1_frequenciesOfInterest[@]}\]`+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S1_frequenciesOfInterest__+${S1_frequenciesOfInterest}+g" "./CONFIGURE.m"
			fi
		   
			# rm STAGE_1.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_ARRAY_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S1_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S1_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S1_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S1_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S1_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S1_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_array__+${S1_SLURM_array}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_licence__+${S1_SLURM_licence}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"
			;;
		2)
			
			# fill values for Stage 2
			sed -i  "s+__S2_MODE__+'${S2_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S2_sourcesPowerFileNamePrefix__+'${S2_sourcesPowerFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S2_dataVarNamePrefix__+'${S2_dataVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S2_rngSeed = 'time' ]
			then
				sed -i  "s+__S2_rngSeed__+'${S2_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S2_rngSeed__+${S2_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S2_trialRejectZ__+${S2_trialRejectZ}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_doZeroShift__+${S2_doZeroShift}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_saveMeanRoiPower__+${S2_saveMeanRoiPower}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_clusteringMethod__+'${S2_clusteringMethod}'+g" "./CONFIGURE.m"
			sed -i  "s+__S2_distanceMetric__+'${S2_distanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S2_nReplicates__+${S2_nReplicates}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_gaussianMixtureRegularization__+${S2_gaussianMixtureRegularization}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_numClustersMode__+'${S2_numClustersMode}'+g" "./CONFIGURE.m"
			sed -i  "s+__S2_nSpectralModesPerROI__+${S2_nSpectralModesPerROI}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_NumClustEval_kList__+`echo \[${S2_NumClustEval_kList[@]}\]+g`" "./CONFIGURE.m"
			sed -i  "s+__S2_NumClustEval_nIterations__+${S2_NumClustEval_nIterations}+g" "./CONFIGURE.m"
			sed -i  "s+__S2_NumClustEval_criterionType__+'${S2_NumClustEval_criterionType}'+g" "./CONFIGURE.m"

			# rm STAGE_2.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_ARRAY_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S2_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S2_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S2_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S2_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S2_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S2_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_array__+${S2_SLURM_array}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_licence__+${S2_SLURM_licence}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			# rm STAGE_2INT.sl and create new one basing on template
			rm STAGE_${iStage}INT.sl
			cp -r templates/STAGE_X_SL_INT_TEMPLATE.sl STAGE_${iStage}INT.sl

			sed -i  "s+__SLURM_jobName__+${S2INT_SLURM_jobName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_queueName__+${S2INT_SLURM_queueName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S2INT_SLURM_nTasksPerNode}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mem__+${S2INT_SLURM_mem}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_time__+${S2INT_SLURM_time}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mailType__+${S2INT_SLURM_mailType}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_${iStage}INT.sl"

			;;
		3)
			# fill values for Stage 3
			sed -i  "s+__S3_dataFileNamePrefix__+'${S3_dataFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S3_dataVarNamePrefix__+'${S3_dataVarNamePrefix}'+g" "./CONFIGURE.m"


			# rm STAGE_3.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_SINGLE_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S3_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S3_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S3_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S3_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S3_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S3_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"


			;;
		4)
			# fill values for Stage 4
			sed -i  "s+__S4_MODE__+'${S4_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S4_pooledClustersFileNamePrefix__+'${S4_pooledClustersFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S4_pooledClustersVarNamePrefix__+'${S4_pooledClustersVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S4_rngSeed = 'time' ]
			then
				sed -i  "s+__S4_rngSeed__+'${S4_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S4_rngSeed__+${S4_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S4_methodName__+'${S4_methodName}'+g" "./CONFIGURE.m"
			sed -i  "s+__S4_criterionType__+'${S4_criterionType}'+g" "./CONFIGURE.m"
			sed -i  "s+__S4_distanceMetric__+'${S4_distanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S4_kList__+`echo \[${S4_kList[@]}\]`+g" "./CONFIGURE.m"
			sed -i  "s+__S4_nIterations__+${S4_nIterations}+g" "./CONFIGURE.m"


			
			# rm STAGE_4.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_ARRAY_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S4_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S4_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S4_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S4_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S4_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S4_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_array__+${S4_SLURM_array}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_licence__+${S4_SLURM_licence}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			# rm STAGE_4INT.sl and create new one basing on template
			rm STAGE_${iStage}INT.sl
			cp -r templates/STAGE_X_SL_INT_TEMPLATE.sl STAGE_${iStage}INT.sl

			sed -i  "s+__SLURM_jobName__+${S4INT_SLURM_jobName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_queueName__+${S4INT_SLURM_queueName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S4INT_SLURM_nTasksPerNode}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mem__+${S4INT_SLURM_mem}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_time__+${S4INT_SLURM_time}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mailType__+${S4INT_SLURM_mailType}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_${iStage}INT.sl"
			
			;;
		5)
			# fill values for Stage 5
			sed -i  "s+__S5_MODE__+'${S5_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S5_pooledClustersFileNamePrefix__+'${S5_pooledClustersFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S5_clusteringEvaluationFileNamePrefix__+'${S5_clusteringEvaluationFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S5_pooledClustersVarNamePrefix__+'${S5_pooledClustersVarNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S5_clusteringEvaluationVarNamePrefix__+'${S5_clusteringEvaluationVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S5_rngSeed = 'time' ]
			then
				sed -i  "s+__S5_rngSeed__+'${S5_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S5_rngSeed__+${S5_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S5_majoritySubjectsNum__+${S5_majoritySubjectsNum}+g" "./CONFIGURE.m"
			sed -i  "s+__S5_clusteringMethod__+'${S5_clusteringMethod}'+g" "./CONFIGURE.m"

			if [ $S5_numberOfClusters = 'optimal' ]
			then
				sed -i  "s+__S5_numberOfClusters__+'${S5_numberOfClusters}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S5_numberOfClusters__+${S5_numberOfClusters}+g" "./CONFIGURE.m"
			fi
			
			sed -i  "s+__S5_distanceMetric__+'${S5_distanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S5_nReplicates__+${S5_nReplicates}+g" "./CONFIGURE.m"
			sed -i  "s+__S5_gaussianMixtureRegularization__+${S5_gaussianMixtureRegularization}+g" "./CONFIGURE.m"
			
			# rm STAGE_5.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_ARRAY_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S5_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S5_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S5_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S5_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S5_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S5_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_array__+${S5_SLURM_array}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_licence__+${S5_SLURM_licence}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			;;
		6)
			# fill values for Stage 6
			sed -i  "s+__S6_MODE__+'${S6_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_dataFileNamePrefix__+'${S6_dataFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_dataVarNamePrefix__+'${S6_dataVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S6_rngSeed = 'time' ]
			then
				sed -i  "s+__S6_rngSeed__+'${S6_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S6_rngSeed__+${S6_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S6_nRepetitions__+${S6_nRepetitions}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_nFolds__+${S6_nFolds}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_save_NLL_Matrices__+${S6_save_NLL_Matrices}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_nClustersSetting__+'${S6_nClustersSetting}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_fixed_nClusters__+${S6_fixed_nClusters}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_clusteringMethod__+'${S6_clusteringMethod}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_distanceMetric__+'${S6_distanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_nReplicates__+${S6_nReplicates}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_gaussianMixtureRegularization__+${S6_gaussianMixtureRegularization}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_majoritySubjectNum__+${S6_majoritySubjectNum}+g" "./CONFIGURE.m"
			sed -i  "s+__S6_optimalClustersDataFile__+'${S6_optimalClustersDataFile}'+g" "./CONFIGURE.m"
			sed -i  "s+__S6_optimalClustersVarName__+'${S6_optimalClustersVarName}'+g" "./CONFIGURE.m"			
			
			# rm STAGE_6.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_SINGLE_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S6_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S6_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S6_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S6_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S6_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S6_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			# rm STAGE_6INT.sl and create new one basing on template
			rm STAGE_${iStage}INT.sl
			cp -r templates/STAGE_X_SL_INT_TEMPLATE.sl STAGE_${iStage}INT.sl

			sed -i  "s+__SLURM_jobName__+${S6INT_SLURM_jobName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_queueName__+${S6INT_SLURM_queueName}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S6INT_SLURM_nTasksPerNode}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mem__+${S6INT_SLURM_mem}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_time__+${S6INT_SLURM_time}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_mailType__+${S6INT_SLURM_mailType}+g" "./STAGE_${iStage}INT.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_${iStage}INT.sl"


			;;
		7)
			# fill values for Stage 7
			sed -i  "s+__S7_MODE__+'${S7_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S7_dataFileNamePrefix__+'${S7_dataFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S7_dataVarNamePrefix__+'${S7_dataVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S7_rngSeed = 'time' ]
			then
				sed -i  "s+__S7_rngSeed__+'${S7_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S7_rngSeed__+${S7_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S7_nRepetitions__+${S7_nRepetitions}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_nFolds__+${S7_nFolds}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_nClustersSetting__+'${S7_nClustersSetting}'+g" "./CONFIGURE.m"
			sed -i  "s+__S7_fixed_nClusters__+${S7_fixed_nClusters}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_clusteringMethod__+'${S7_clusteringMethod}'+g" "./CONFIGURE.m"
			sed -i  "s+__S7_distanceMetric__+'${S7_distanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S7_nReplicates__+${S7_nReplicates}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_gaussianMixtureRegularization__+${S7_gaussianMixtureRegularization}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_NumClustEval_kList__+`echo \[${S7_NumClustEval_kList[@]}\]`+g" "./CONFIGURE.m"
			sed -i  "s+__S7_NumClustEval_nIterations__+${S7_NumClustEval_nIterations}+g" "./CONFIGURE.m"
			sed -i  "s+__S7_NumClustEval_criterionType__+'${S7_NumClustEval_criterionType}'+g" "./CONFIGURE.m"


			# rm STAGE_7.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_ARRAY_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S7_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S7_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S7_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S7_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S7_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S7_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_array__+${S7_SLURM_array}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_licence__+${S7_SLURM_licence}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			;;
		8)
			# fill values for Stage 8
			sed -i  "s+__S8_MODE__+'${S8_MODE}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_pooledClustersFileNamePrefix__+'${S8_pooledClustersFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_spectralFingerprintsFileNamePrefix__+'${S8_spectralFingerprintsFileNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_pooledClustersVarNamePrefix__+'${S8_pooledClustersVarNamePrefix}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_spectralFingerprintsVarNamePrefix__+'${S8_spectralFingerprintsVarNamePrefix}'+g" "./CONFIGURE.m"
			if [ $S8_rngSeed = 'time' ]
			then
				sed -i  "s+__S8_rngSeed__+'${S8_rngSeed}'+g" "./CONFIGURE.m"
			else
				sed -i  "s+__S8_rngSeed__+${S8_rngSeed}+g" "./CONFIGURE.m"
			fi
			sed -i  "s+__S8_linkageMethod__+'${S8_linkageMethod}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_linkageDistanceMetric__+'${S8_linkageDistanceMetric}'+g" "./CONFIGURE.m"
			sed -i  "s+__S8_nSimilarityClusters__+${S8_nSimilarityClusters}+g" "./CONFIGURE.m"
			sed -i  "s+__S8_majoritySubjectsNum__+${S8_majoritySubjectsNum}+g" "./CONFIGURE.m"

			# rm STAGE_8.sl and create new one basing on template
			rm STAGE_$iStage.sl
			cp -r templates/STAGE_X_SL_SINGLE_TEMPLATE.sl STAGE_$iStage.sl

			sed -i  "s+__SLURM_jobName__+${S8_SLURM_jobName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_queueName__+${S8_SLURM_queueName}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_nTasksPerNode__+${S8_SLURM_nTasksPerNode}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mem__+${S8_SLURM_mem}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_time__+${S8_SLURM_time}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_mailType__+${S8_SLURM_mailType}+g" "./STAGE_$iStage.sl"
			sed -i  "s+__SLURM_stage__+$iStage+g" "./STAGE_$iStage.sl"

			;;
		*)
			echo 'ERROR! Stage ' $iStage 'unavailable for configuration.'
			exit 1
			;;
	esac

done

# substitute leftover __X__ with [] to prevent matlab error
echo "Treating empty entries ..."
sed -i -E "s/__.+__/`echo \[\]`/g" "./CONFIGURE.m" # UNCOMMENT !!!

if [ $IS_LINUX -eq 1 ]
then
    echo "Running matlab ..."
    mycmd=(${MATLAB_RUNPATH} -nodisplay -nosplash -nodesktop -nojvm -r "run('CONFIGURE.m');exit;")
	"${mycmd[@]}"	
else
    echo 'Now open MATLAB and run CONFIGURE.m script to finish configuration.'
fi

################################################################################
