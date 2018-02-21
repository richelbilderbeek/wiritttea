# Table 109: Successes and reasons of failures
library(wiritttea)
options(warn = 2) # Be strict
log_files_filename <- "~/log_files_20170710.csv"
table_109_filename <- "~/table_109.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) log_files_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("log_files_filename:", log_files_filename))

print("Create log_files data file if absent")
if (!file.exists(log_files_filename)) {
  stop("Log files' info is absent, please run analyse_log_files")
}

print("Load log files info")
df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename)

write.csv(df_log_files, table_109_filename)

# Why did these fail?
ggplot2::ggplot(
  data = df_log_files,
  ggplot2::aes(x = exit_status)
) +
  ggplot2::geom_bar() +
  ggplot2::scale_y_log10() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))

