#!/bin/bash
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --job-name=collect_esses
#SBATCH --output=collect_esses.log
module load R/3.3.1-foss-2016a
time Rscript collect_esses.R
