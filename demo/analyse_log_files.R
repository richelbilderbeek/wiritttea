# Analyse the log files
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
log_files_filename <- paste0("~/log_files_info_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) log_files_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("log_files_filename:", log_files_filename))

print("Create log_files data file if absent")
if (!file.exists(log_files_filename)) {
  print("File is absent, recreating")

  print("Collecting .log files")
  my_filenames <- list.files(path_data, pattern = "(article|add).*[[:digit:]]\\.log", full.names = TRUE)

  print("Collecting log files info")
  df_log_files <- wiritttea::collect_log_files_info(filenames = my_filenames, show_progress = TRUE)

  print("Saving log files info")
  write.csv(df_log_files, log_files_filename)
}

print("Load log files info")
df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename)
