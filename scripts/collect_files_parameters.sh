#!/bin/bash
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --job-name=collect_files_parameters
#SBATCH --output=collect_files_parameters.log
module load R/3.3.1-foss-2016a
time Rscript collect_files_parameters.R
