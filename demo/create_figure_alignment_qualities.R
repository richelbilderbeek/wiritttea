# # Create figure_alignment_qualities: quality of the alignments
# library(wiritttea)
# options(warn = 2) # Be strict
# date <- "20170710"
# alignments_filename <- paste0("~/GitHubs/wirittte_data/alignments_", date, ".csv")
#
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) > 0) alignments_filename <- args[1]
#
# print(paste("alignments_filename:", alignments_filename))
#
# if (!file.exists(alignments_filename)) {
#   stop("file absent, please run analyse_alignments.R")
# }
#
# print("Load alignments data")
# df_alignments <- wiritttea::read_collected_alignments(alignments_filename)
#
# head(df_alignments)
#
#
# df <- data.frame(
#   status = c("ok", "zero", "na"),
#   n = c(
#     sum(df_alignments$n_alignments_ok),
#     sum(df_alignments$n_alignments_zeroes),
#     sum(df_alignments$n_alignments_na)
#   )
# )
# df$status <- as.factor(df$status)
#
# svg("~/figure_alignment_qualities.svg")
# ggplot2::ggplot(
#   data = df,
#   ggplot2::aes(x = status, y = n, fill = status)
# ) + ggplot2::geom_col() +
#     ggplot2::ylab(label = "count") +
#     ggplot2::labs(
#     fill = "quality",
#     title = "Alignment qualities",
#     caption  = "Figure 220"
#   ) +
#   ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
# dev.off()
