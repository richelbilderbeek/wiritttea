# Analyse if the two sampled species trees are identical
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
strees_filename <- paste0("~/GitHubs/wirittte_data/strees_identical_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) strees_filename <- args[1]

print(paste("strees_filename:", strees_filename))


if (!file.exists(strees_filename)) {
  stop("File '", strees_filename,"' is absent, please run 'analyse_strees_identical")
}

print("Load strees data")
df_strees <- wiritttea::read_collected_strees_identical(strees_filename)

head(df_strees)

png("~/figure_210.png")
# svg("~/figure_210.svg")
ggplot2::ggplot(
  df_strees,
  ggplot2::aes(x = strees_identical, fill = strees_identical)
) + ggplot2::geom_bar() +
    ggplot2::xlab("") +
    ggplot2::labs(
    title = "How often do sampled species trees differ?",
    caption  = "Figure 210",
    fill = "Are the\nsampled\nspecies tree\ndifferent?") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
