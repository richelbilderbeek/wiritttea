# Analyse if the alignments are created successfully
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170523"
path_data <- paste0("~/wirittte_data/", date)
alignments_filename <- paste0("~/GitHubs/wirittte_data/alignments_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) alignments_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignments_filename:", alignments_filename))

if (!file.exists(alignments_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  df <- wiritttea::collect_files_alignments(my_filenames, show_progress = TRUE)
  write.csv(df, alignments_filename)
}

print("Load alignments data")
df_alignments <- wiritttea::read_collected_alignments(alignments_filename)
