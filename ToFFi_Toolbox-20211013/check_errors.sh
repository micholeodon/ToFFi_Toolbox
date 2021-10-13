#!/bin/bash

# This script searches for lines containing "error" and "undefined"
# (case insensitive) word in *.log and *.out files and write them
# in errors.log file as an output.
#
# USAGE:
# 1. Run in shell: . check_errors.sh 

echo 'Preparing error log file ...'
thisdir=`pwd`
error_log_file=$thisdir/errors.log
tmp_file=$thisdir/tmp_file_check_errors_routine
rm $error_log_file
touch $tmp_file

grep -Hni "error" *.log  >> $tmp_file
grep -Hni "error" *.out  >> $tmp_file
grep -Hni "slurmstepd: error:" *.out  >> $tmp_file
grep -Hni "undefined" *.log  >> $tmp_file
grep -Hni "undefined" *.out  >> $tmp_file

mv $tmp_file $error_log_file
   
echo DONE! Check ${error_log_file} 



