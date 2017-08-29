# figure_run_times: distribution of runtimes
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
log_files_filename <- paste0("~/GitHubs/wirittte_data/log_files_info_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) log_files_filename <- args[1]

print(paste("log_files_filename:", log_files_filename))

print("Create log_files data file if absent")
if (!file.exists(log_files_filename)) {
  stop("File is absent, please run analyse_log_file_info")
}

print("Load log files info")
df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename)

svg("~/figure_run_times.svg")
ggplot2::ggplot(
  data = df_log_files[ df_log_files$sys_time > 600,  ],
  ggplot2::aes(x = sys_time, fill = exit_status)
) + ggplot2::geom_histogram(binwidth = 600, na.rm = TRUE) +
  ggplot2::scale_x_continuous(breaks = seq(3600, 36000, 3600)) +
  ggplot2::labs(
    title = "Distribution of run-times",
    fill = "Exit status",
    caption = "Figure 200"
  ) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
