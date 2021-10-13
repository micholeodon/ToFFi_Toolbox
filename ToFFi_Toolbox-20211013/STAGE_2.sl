#!/bin/bash
#SBATCH -J H1_S2
#SBATCH -p small
#SBATCH --oversubscribe
#SBATCH -N 1
#SBATCH --ntasks-per-node 3
#SBATCH --mem 12800
#SBATCH --time 00:10:00
#SBATCH --mail-type=NONE
#SBATCH --array=1-1
#SBATCH --output=S2-%A_%a.out
#SBATCH --license=matlab_dct@licencje.task.gda.pl:1

iStage=2

cd "STAGE_$iStage/scripts/"
folder=`pwd`
module load tryton/matlab/2021a
matlab -nodisplay -nodesktop -logfile $folder/../../STAGE_${iStage}.log <  $folder/RUN.m 

# WARNING ! ####################################################################
# This SLURM script is suited to run Spectral Fingerprinting on cluster at
# CI-TASK in Gdansk, Poland. To use it elsewhere, modify it according to
# instructions related to computing center of your choice.
################################################################################
