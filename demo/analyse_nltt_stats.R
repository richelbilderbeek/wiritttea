# Analyse the nLTT stats
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/Peregrine", date)
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(nltt_stats_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  df_nltt_stats <- wiritttea::collect_files_nltt_stats_dirty(my_filenames)
  write.csv(df_nltt_stats, nltt_stats_filename)
}

