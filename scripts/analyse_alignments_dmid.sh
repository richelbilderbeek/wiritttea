#!/bin/bash
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --job-name=analyse_alignments_dmid
#SBATCH --output=analyse_alignments_dmid.log
module load R/3.3.1-foss-2016a
time Rscript analyse_alignments_dmid.R $@
