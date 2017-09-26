# Analyse the number of taxa
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/nltt_stats_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/parameters_stub.csv'")
}

path_data <- args[1]
nltt_stats_filename <- args[2]

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))

my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
df_nltt_stats <- wiritttea::collect_files_nltt_stats_dirty(my_filenames)
write.csv(df_nltt_stats, nltt_stats_filename)
