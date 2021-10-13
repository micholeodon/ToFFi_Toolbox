#!/bin/bash
#SBATCH -J __SLURM_jobName__
#SBATCH -p __SLURM_queueName__
#SBATCH --oversubscribe
#SBATCH -N 1
#SBATCH --ntasks-per-node __SLURM_nTasksPerNode__
#SBATCH --mem __SLURM_mem__
#SBATCH --time __SLURM_time__
#SBATCH --mail-type=__SLURM_mailType__
#SBATCH --output=S__SLURM_stage__-%A.out

iStage=__SLURM_stage__

cd "STAGE_$iStage/scripts/"
folder=`pwd`
module load tryton/matlab/2021a
matlab -nodisplay -nodesktop -logfile $folder/../../STAGE_${iStage}.log <  $folder/RUN.m 

# WARNING ! ####################################################################
# This SLURM script is suited to run Spectral Fingerprinting on cluster at
# CI-TASK in Gdansk, Poland. To use it elsewhere, modify it according to
# instructions related to computing center of your choice.
################################################################################
