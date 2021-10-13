#!/bin/bash
#SBATCH -J H1_S6
#SBATCH -p small
#SBATCH --oversubscribe
#SBATCH -N 1
#SBATCH --ntasks-per-node 24
#SBATCH --mem 128000
#SBATCH --time 01:00:00
#SBATCH --mail-type=ALL
#SBATCH --output=S6-%A.out

iStage=6

cd "STAGE_$iStage/scripts/"
folder=`pwd`
module load tryton/matlab/2021a
matlab -nodisplay -nodesktop -logfile $folder/../../STAGE_${iStage}.log <  $folder/RUN.m 

# WARNING ! ####################################################################
# This SLURM script is suited to run Spectral Fingerprinting on cluster at
# CI-TASK in Gdansk, Poland. To use it elsewhere, modify it according to
# instructions related to computing center of your choice.
################################################################################
