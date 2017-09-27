# Collects the number of species trees used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/log_files_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/parameters_stub.csv'")
}

path_data <- args[1]
log_files_filename <- args[2]

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) log_files_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("log_files_filename:", log_files_filename))

print("Collecting .log files")
my_filenames <- list.files(path_data, pattern = "add.*[[:digit:]]\\.log", full.names = TRUE)

print("Collecting log files info")
df_log_files <- wiritttea::collect_log_files_info(filenames = my_filenames, show_progress = TRUE)

print("Saving log files info")
write.csv(df_log_files, log_files_filename)
