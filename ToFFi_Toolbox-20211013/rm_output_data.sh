#!/bin/bash
# Script for 
# - erasing content  from STAGE_*/output/ directory
#
# USAGE:
# 1. To clean selected stages output (e.g. output from stages 3 7 6)
#    run in shell: . rm_output_data.sh 3 7 6
# OR
# 1. Modify value of rm_out_stages variable below. 
# 2. Run in shell without command line arguments: . rm_output_data.sh 

# ### SETTINGS #####################################
declare -a rm_out_stages=(1 2 3 4 5 6 7 8) # all: rm_out_stages=(1 2 3 4 5 6 7 8)
# WARNING ! It will take effect if no command line arguments were passed !
####################################################

if [ $# -eq 0 ]
then
    echo "WARNING: No argument supplied ! Cleaning stages defined inside rm_output_data.sh script ..."
else
	rm_out_stages=( "$@" )
fi

echo "Declared stages to be cleared.  <-- PLEASE CHECK "
echo "${rm_out_stages[@]}"
echo "Root directory where stages directories reside:  <-- PLEASE CHECK "
echo `pwd`  
read -r -p "Are you sure you want to remove output data? [y/N] " responseRM


case "$responseRM" in
    [yY][eE][sS]|[yY])
        echo "Removing output data  ..."

		for i in `seq 0 $((${#rm_out_stages[@]}-1))`
		do
			iStage=${rm_out_stages[$i]}

			echo "Removing data from STAGE_$iStage ..."
			find STAGE_$iStage/output/. -exec rm -fr {} +
			
		done
		
        echo "OK. Done."
        ;;
    *)
        echo "Ok. Aborted. ...."
        ;;
esac
