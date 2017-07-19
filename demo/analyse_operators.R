# Analyse the BEAST2 operators, as found in the .xml.state files
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
operators_filename <- paste0("~/operators_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) operators_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("operators_filename:", operators_filename))

print("Create operators file if absent")
if (!file.exists(operators_filename)) {
  print("File is absent, recreating")

  print("Collecting .xml.state files")
  my_filenames <- list.files(path_data, pattern = ".*\\.xml\\.state", full.names = TRUE)

  print("Collecting operators")
  df_operators <- wiritttea::collect_files_operators(filenames = my_filenames)

  print("Saving operators")
  write.csv(df_operators, operators_filename)
}

print("Load log files info")
df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename)
