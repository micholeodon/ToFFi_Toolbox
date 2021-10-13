#!/bin/bash
#SBATCH -J H1_S2INT
#SBATCH -p serial
#SBATCH --oversubscribe
#SBATCH -N 1
#SBATCH --ntasks-per-node 24
#SBATCH --mem 64000
#SBATCH --time 00:20:00
#SBATCH --mail-type=ALL
#SBATCH --output=S2INT-%A.out

iStage=2

cd "STAGE_$iStage/scripts/"
folder=`pwd`
module load tryton/matlab/2021a
matlab -nodisplay -nodesktop -logfile $folder/../../STAGE_${iStage}INT.log <  $folder/INTEGRATE.m 

# WARNING ! ####################################################################
# This SLURM script is suited to run Spectral Fingerprinting on cluster at
# CI-TASK in Gdansk, Poland. To use it elsewhere, modify it according to
# instructions related to computing center of your choice.
################################################################################
