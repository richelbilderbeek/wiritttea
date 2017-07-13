# Figure 113: Distribution of ESSes
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]

if (!file.exists(esses_filename)) {
  stop("esses_filename absent, please run analyse_esses.R")
}

#Investigations
df_esses <- wiritttea::read_collected_esses(esses_filename)


mean_ess <- mean(na.omit(df_esses$min_ess))
median_ess <- median(na.omit(df_esses$min_ess))

png("~/figure_113.png")
#svg("~/figure_113.svg")
ggplot2::ggplot(
  data = subset(df_esses, !is.na(min_ess)),
  ggplot2::aes(min_ess)) +
  ggplot2::geom_histogram() +
  ggplot2::labs(
    title = "The distribution of Effective Sample Sizes",
    x = "Effective Sample Size",
    y = "Count",
    caption = "Figure 113"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::geom_vline(xintercept = median_ess, linetype = "dotted") +
  ggplot2::geom_vline(xintercept = mean_ess, linetype = "dashed")
dev.off()
