# Create figure 'figure_exit_statuses'
library(wiritttea)
options(warn = 2) # Be strict
log_files_filename <- "~/GitHubs/wirittte_data/log_files_info_20170710.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) log_files_filename <- args[2]

print(paste("log_files_filename:", log_files_filename))

print("Create log_files data file if absent")
if (!file.exists(log_files_filename)) {
  stop("Log files' info is absent, please run analyse_log_files")
}

print("Load log files info")
df_log_files <- wiritttea::read_collected_log_files_info(log_files_filename)

# Create figure
svg("~/figure_exit_statuses.svg")

ggplot2::ggplot(
  data = df_log_files[ df_log_files$exit_status != "OK" & !is.na(df_log_files$exit_status), ],
  ggplot2::aes(x = "", fill = exit_status)
) +
  ggplot2::geom_bar() +
  ggplot2::coord_polar("y", start = 0) +
  ggplot2::xlab("Count") +
  ggplot2::labs(
    fill = "Exit status",
    title = "Reasons why simulation failed",
    caption  = "figure_exit_statuses"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
