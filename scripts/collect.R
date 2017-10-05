#!/usr/bin/env Rscript
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  args <- c("/home/richel/wirittte_data", "stub")
}

if (length(args) < 1) {
  stop("Please add the source superfolder as a first argument, e.g. '~/wirittte_data'")
}
if (length(args) < 2) {
  stop("Please add the date as a second argument, e.g. '20170711'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source superfolder and a source subfolder, ",
    "e.g. '~/wirittte_data/stub 20170711'")
}

source_superfolder <- args[1]
date <- args[2]

# Variable initialization
print(paste0("source_superfolder: ", source_superfolder))
print(paste0("date: ", date))

source_folder <- paste0(source_superfolder, "/", date)
print(paste0("source_folder: ", source_folder))

# Checking inputs
if (dir.exists(source_superfolder)) {
  print("OK: source super folder is a folder")
} else {
  stop("ERROR: source super folder is not a folder")
}

if (dir.exists(source_folder)) {
  print("OK: source folder is a folder")
} else {
  stop("ERROR: source folder is not a folder")
}

# Prepare commands
cmds <- c(
  paste0("./collect_log_files ", source_folder, " ", source_superfolder, "/log_files_", date, ".csv"),
  paste0("./collect_posterior_likelihoods ", source_folder, " ", source_superfolder, "/posterior_likelihoods_", date, ".csv"),
  paste0("./collect_posterior_crown_ages ", source_folder, " ", source_superfolder, "/posterior_crown_ages_", date, ".csv"),
  paste0("./collect_operators ", source_folder, " ", source_superfolder, "/operators_", date, ".csv"),
  paste0("./collect_strees_identical ", source_folder, " ", source_superfolder, "/collect_strees_identical_", date, ".csv"),
  paste0("./collect_alignments ", source_folder, " ", source_superfolder, "/alignments_", date, ".csv"),
  paste0("./collect_alignments_dmid ", source_folder, " ", source_superfolder, "/alignments_dmid_", date, ".csv"),
  paste0("./collect_parameters ", source_folder, " ", source_superfolder, "/parameters_", date, ".csv"),
  paste0("./collect_n_taxa ", source_folder, " ", source_superfolder, "/n_taxa_", date, ".csv"),
  paste0("./collect_n_species_trees ", source_folder, " ", source_superfolder, "/n_species_trees_", date, ".csv"),
  paste0("./collect_n_alignments ", source_folder, " ", source_superfolder, "/n_alignments_", date, ".csv"),
  paste0("./collect_n_posteriors ", source_folder, " ", source_superfolder, "/n_posteriors_", date, ".csv"),
  paste0("./collect_esses ", source_folder, " ", source_superfolder, "/esses_", date, ".csv"),
  paste0("./collect_nltt_stats ", source_folder, " ", source_superfolder, "/nltt_stats_", date, ".csv")
)

# Don't care about output
cmds <- paste0(cmds, " >/dev/null")

# Run the commands in sequence
for (cmd in cmds) {
  system(cmd)
}

# on_peregrine <- Sys.getenv("HOSTNAME") == "peregrine.hpc.rug.nl"
# print(paste0("on_peregrine: ", on_peregrine))
# if [[ $on_peregrine == 1 ]]; then
#   cmd="sbatch --dependency=afterany:$jobid "$cmd
#   echo "cmd: "$cmd
#   jobid=`$cmd | cut -d ' ' -f 4`
#   echo "jobid: "$jobid
# else
#   echo "cmd: "$cmd
#   eval $cmd >/dev/null
# fi


