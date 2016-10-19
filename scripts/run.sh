#!/bin/bash

##########################
# Clean up
##########################
rm *.txt
rm *.log
rm *.csv
rm *.pdf
rm *.md

##########################
# Update other packages
##########################

jobid=`sbatch install_r_packages.sh | cut -d ' ' -f 4`
echo "jobid: "$jobid

##########################
# Update this package
##########################

cmd="sbatch --dependency=afterok:$jobid install_this_r_package.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

##########################
# Check parameter file creation success
##########################

cmd="sbatch --dependency=afterany:$jobid collect_files_parameters.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

##################
# Collect n taxa #
##################

cmd="sbatch --dependency=afterany:$jobid collect_n_taxa.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n species trees
############################

cmd="sbatch --dependency=afterany:$jobid collect_n_species_trees.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n alignments
############################

cmd="sbatch --dependency=afterany:$jobid collect_files_n_alignments.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n posteriors
############################

cmd="sbatch --dependency=afterany:$jobid collect_files_n_posteriors.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

##########################
# Analysis
##########################

cmd="sbatch --dependency=afterany:$jobid collect_esses.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid collect_gammas.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid collect_nrbss.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid collect_nltts.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid collect_nltt_stats.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid collect_times.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid analyse_esses.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid analyse_nltt_stats.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid analyse_time.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch --dependency=afterany:$jobid send_me_an_email.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid
