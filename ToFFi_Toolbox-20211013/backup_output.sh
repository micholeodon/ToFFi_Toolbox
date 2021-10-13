#!/bin/bash
#
# Tool for selective backup.
# Each backup is identified by the date of creation and suffix (set by the user).
# You can also edit the prefix ('backup_' is default).
#
# NOTE ! Avoid whitespaces.
#
# USAGE:
# 1. Modify prefix, number, suffix1 and suffix2 variables (hints in comments)
# 2. Run in shell: . backup_output.sh 

################################################################################

# CHOOSE STAGES TO BACKUP
declare -a stages=(1 2 3 4 5 6 7 8) # e.g. stages=(1 2 5 3)

prefix=backup_     # add _ at the end
number=`date +'%Y-%m-%d'`

# !!! START WITH UNDERSCORE _
suffix1=_my_run_of_illustrative_example

# OPTIONAL; !!! START WITH UNDERSCORE _ IF suffix2 VARIABLE NOT EMPTY
suffix2=; 

################################################################################

backupDir=$prefix$number$suffix1$suffix2 

# adds header with current backup identifier
echo $prefix$number > output_list.log

# adds newlines
echo > output_list.log
echo > output_list.log

# finds all output files, no symlinks, not counting already backuped files
find `pwd -P` | grep /STAGE_ --color=always | grep output | grep -v backup >> output_list.log

mkdir $backupDir

# does backup to dir with correct prefix and number
for iStage in "${stages[@]}"
do
    rsync -hvvaz --partial --progress --checksum STAGE_${iStage}/output ${backupDir}/STAGE_${iStage}
done

# copy configure so you can recreate results
rsync -hvvaz --progress --checksum CONFIGURE.m ${backupDir}/CONFIGURE.m

