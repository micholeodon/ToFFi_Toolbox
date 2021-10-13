#!/bin/sh

# Shell script for running selected slurm jobs.
#
# USAGE:
# 1. To run selected stages output (e.g. output from stages 3 7 6)
#    run in shell: . RUN_SELECTED.sh 3 7 6
# OR
# 1. Modify value of stages variable below.
# 2. Run in shell: . RUN_SELECTED.sh



# ### SETTINGS ####################################
declare -a stages=(1 2 3 4 5 6 7 8) # all: stages=(1 2 3 4 5 6 7 8)
# WARNING ! These stages will be ran if no arguments supplied
####################################################

# ### FUNCTIONS ####################################
ExtractJobID(){
    echo "MESSAGE: ${message}"
    # Extract job identifier from SLURM's message.
    if ! echo ${message} | grep -q "[1-9][0-9]*$"; then
		echo "Job(s) submission failed."
		exit 1
    else
		job=$(echo ${message} | grep -oh "[1-9][0-9]*$")
    fi
}

####################################################


if [ $# -eq 0 ]
then
    echo "WARNING: No arguments supplied ! Launching stages defined inside RUN_SELECTED.sh script ..."
else
	stages=( "$@" )
fi


read -r -p "Did you run CONFIGURE.m before to prepare config files and manage old data? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo "OK ! Ready to run ! Starting ..."
        isReady=true
        ;;
    *)
        echo "RUN CONFIGURE.m first !"
		isReady=0
        ;;
esac



if [ "$isReady" == "true" ]
then
	# ### Submitting jobs ##############################

	# first job on the list
	echo "Submitting job  ..."
	iStage=${stages[0]}
	message=$(sbatch STAGE_$iStage.sl)
	ExtractJobID
	echo "EXTRACTED JOB ID: ${job}"

	# Run INTEGRATE if needed
	if [ $iStage -eq 2 ]
	then
 		echo "Submitting job  ..."
		message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
		ExtractJobID
		echo "EXTRACTED JOB ID: ${job}"			
	fi
	
	if [ $iStage -eq 4 ]
	then
 		echo "Submitting job  ..."
		message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
		ExtractJobID
		echo "EXTRACTED JOB ID: ${job}"			
	fi

	if [ $iStage -eq 6 ]
	then
 		echo "Submitting job  ..."
		message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
		ExtractJobID
		echo "EXTRACTED JOB ID: ${job}"			
	fi	

	
	# rest of the jobs
	for i in `seq 1 $((${#stages[@]}-1))`
	do
		iStage=${stages[$i]}
 		echo "Submitting job  ..."
		message=$(sbatch --dependency=afterok:${job} STAGE_$iStage.sl)
		ExtractJobID
		echo "EXTRACTED JOB ID: ${job}"

		if [ $iStage -eq 2 ]
		then
 			echo "Submitting job  ..."
			message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
			ExtractJobID
			echo "EXTRACTED JOB ID: ${job}"			
		fi
		
		if [ $iStage -eq 4 ]
		then
 			echo "Submitting job  ..."
			message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
			ExtractJobID
			echo "EXTRACTED JOB ID: ${job}"			
		fi

		if [ $iStage -eq 6 ]
		then
 			echo "Submitting job  ..."
			message=$(sbatch --dependency=afterok:${job} STAGE_${iStage}INT.sl)
			ExtractJobID
			echo "EXTRACTED JOB ID: ${job}"			
		fi	
		
	done

	squeue -u $USER

	####################################################
fi
