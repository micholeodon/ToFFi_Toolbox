#!/bin/bash
#SBATCH -J H1_S3
#SBATCH -p serial
#SBATCH --oversubscribe
#SBATCH -N 1
#SBATCH --ntasks-per-node 24
#SBATCH --mem 16000
#SBATCH --time 00:30:00
#SBATCH --mail-type=ALL
#SBATCH --output=S3-%A.out

iStage=3

cd "STAGE_$iStage/scripts/"
folder=`pwd`
module load tryton/matlab/2021a
matlab -nodisplay -nodesktop -logfile $folder/../../STAGE_${iStage}.log <  $folder/RUN.m 

# WARNING ! ####################################################################
# This SLURM script is suited to run Spectral Fingerprinting on cluster at
# CI-TASK in Gdansk, Poland. To use it elsewhere, modify it according to
# instructions related to computing center of your choice.
################################################################################
