#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --job-name=analyse_n_taxa
#SBATCH --output=analyse_n_taxa.log
module load R/3.3.1-foss-2016a
time Rscript analyse_n_taxa.R $@
