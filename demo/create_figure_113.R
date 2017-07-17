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
head(df_esses)

# Melt data, convert to long form
df_esses_long <- reshape2::melt(df_esses,
  id = c("filename", "sti", "ai", "pi")
)
testit::assert(is.factor(df_esses_long$variable))

df_esses_long <- dplyr::rename(df_esses_long, parameter = variable)
df_esses_long <- dplyr::rename(df_esses_long, ess = value)


head(df_esses_long)
#mean_esses <- colMeans(df_esses)
#median_ess <- median(na.omit(df_esses$min_ess))


png("~/figure_113.png")
#svg("~/figure_113.svg")
ggplot2::ggplot(
  data = na.omit(df_esses_long),
  ggplot2::aes(x = ess, fill = parameter)) +
  ggplot2::geom_histogram(alpha = 0.5, position = "identity", binwidth = 10) +
  ggplot2::labs(
    title = "The distribution of Effective Sample Sizes per parameter estimate",
    x = "Effective Sample Size",
    y = "Count",
    caption = "Figure 113"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::geom_vline(xintercept = 200, linetype = "dashed")
dev.off()
