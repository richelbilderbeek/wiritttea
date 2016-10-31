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

cmd="sbatch collect_files_parameters.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

##################
# Collect n taxa #
##################

cmd="sbatch collect_n_taxa.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n species trees
############################

cmd="sbatch collect_n_species_trees.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n alignments
############################

cmd="sbatch collect_files_n_alignments.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

############################
# Collect n posteriors
############################

cmd="sbatch collect_files_n_posteriors.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

##########################
# Analysis
##########################

cmd="sbatch collect_esses.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch collect_gammas.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch collect_nrbss.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch collect_nltts.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch collect_nltt_stats.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch collect_times.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch analyse_esses.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch analyse_nltt_stats.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid

cmd="sbatch analyse_time.sh"
echo "cmd: "$cmd
jobid=`$cmd | cut -d ' ' -f 4`
echo "jobid: "$jobid
