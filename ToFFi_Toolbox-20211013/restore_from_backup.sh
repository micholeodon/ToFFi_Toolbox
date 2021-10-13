#!/bin/bash
#
# Tool for selective backup restoration.
# It copies output data from selected backup directory and puts inside output directories
# in each STAGE directory.
#
# NOTE: Configuration file stays in the backup directory (it is not copied).
#
# USAGE:
# Suppose you have backup directory called 'backup_2020-11-20'.
# 1. Modify value of stages variable below.
# 2. Run in shell: . restore_from_backup.sh backup_2020-11-20

# which stages to restore data from
declare -a stages=(1 2 3 4 5 6 7 8)

backupDir=$1

if [ $# -eq 0 ]
then
    echo "WARNING: No argument (backup dir name) supplied ! Aborted."
    exit
fi

restoreOutputFromBackup()
{
    for iStage in "${stages[@]}"
    do
		echo "Restoring data from STAGE_$iStage ..."
		rsync -hvvaz --partial --progress  ${backupDir}/STAGE_${iStage}/output STAGE_${iStage}/.
    done
    
    echo 'ALL DONE !'
}

restoreOutputFromBackup




