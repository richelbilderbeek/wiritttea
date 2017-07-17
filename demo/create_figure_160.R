# Table 109: Successes and reasons of failures
library(wiritttea)
options(warn = 2) # Be strict
log_files_filename <- "~/GitHubs/wirittte_data/log_files_20170710.csv"
table_109_filename <- "~/table_109.csv"

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

# Create figure 160
png("~/figure_160.png")
# svg("~/figure_160.svg")
ggplot2::ggplot(
  data = df_log_files[ df_log_files$exit_status != "OK", ],
  ggplot2::aes(x = exit_status, fill = exit_status)
) +
  ggplot2::geom_bar() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
  ggplot2::ggtitle("Reasons why simulation failed") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::labs(caption = "Figure 160: exit statuses of simulations")
dev.off()
