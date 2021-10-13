#!/bin/sh
# This is script for 
# - erasing all logs from parallel computations
# - erasing ~ files
#
# USAGE:
# 1. Run in shell: . rm_logs_autosaves.sh 

echo "Called script for log files removal."
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        echo "Erasing .log .out and ~files ..."
        rm -v *.log
        rm -v *.out   
        rm -v *~
        echo "Done !"
        ;;
     *)
        echo "Ok. Aborted."
        ;;
esac
