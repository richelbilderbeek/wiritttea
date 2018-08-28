# Create 'figure_posterior_distributions_nltts'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
posteriors_path <- paste0("~/wirittte_data/", date, "/")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]

print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run analyse_nltt_stats")
}

print("Read nLTT stats")
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)
names(nltt_stats)

testit::assert("pi" %in% names(nltt_stats))
`%>%` <- dplyr::`%>%`

print("Split nLTT stats of first and second posterior")
df <- tidyr::spread(nltt_stats, pi, nltt_stat) %>% rename(pi1 = "1", pi2 = "2")

print("Remove NA column")
df <- dplyr::select(df, -starts_with("<NA>"))
testit::assert(names(df) == c("filename", "sti", "ai", "si", "pi1", "pi2"))

print("Remove NAs")
df <- stats::na.omit(df)

df <- dplyr::group_by(.data = df, filename, sti, ai)

safe_mann_whitney <- function(pi1, pi2)
{
  p <- NA
  tryCatch(
      p <- stats::wilcox.test(
        pi1,
        pi2,
        correct = FALSE,
        exact = FALSE, # cannot compute exact p-value with ties
        na.action = stats::na.omit
      )$p.value,
      error = function(cond) {} # nolint
    )
  p
}

df <- df %>% dplyr::summarize(p_value = safe_mann_whitney(pi1, pi2))

df <- stats::na.omit(df)

svg("~/figure_posterior_distribution_nltts.svg")
ggplot2::ggplot(
  df,
  ggplot2::aes(x = p_value, na.omit = TRUE)
) +
  ggplot2::geom_histogram(binwidth = 0.01) +
  ggplot2::geom_vline(xintercept = 0.05, linetype = "dotted") +
  ggplot2::xlab("p value") +
  ggplot2::ylab("Count") +
  ggplot2::labs(
    title = "The distribution of p values of Mann-Whitney tests\nbetween posterior nLTT statistics",
    caption  = "figure_posterior_distribution_nltts"
  ) +
  ggplot2::annotate("text", x = c(0.0, 0.125), y = 325, label = c("different", "same")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

dev.off()










# Show posterior with low, median and high p value
low  <- df[which(df$p_value == min(df$p_value)), ]
low_filename <- paste0(posteriors_path, low$filename[1])
low_sti <- as.numeric(low$sti[1])
low_ai <- as.numeric(low$ai[1])
low_df <- wiritttea::collect_file_nltt_stats(low_filename)

low_nltts1 <- low_df[which(low_df$sti == low_sti & low_df$ai == low_ai & low_df$pi == 1), ]$nltt_stat
low_nltts2 <- low_df[which(low_df$sti == low_sti & low_df$ai == low_ai & low_df$pi == 2), ]$nltt_stat
df_low <- data.frame(
  pi = as.factor(c(rep(1, length(low_nltts1)), rep(2, length(low_nltts2)))),
  nltt  = c(low_nltts1, low_nltts2)
)

svg("~/figure_posterior_distribution_nltts_low.svg")
options(warn = 1) # Allow outliers not to be plotted
ggplot2::ggplot(
  stats::na.omit(df_low),
  ggplot2::aes(x = nltt, fill = pi)
) +
  ggplot2::geom_histogram(binwidth = 0.001, position = "identity", alpha = 0.25) +
  ggplot2::xlab("tree nltt") +
  ggplot2::ylab("Count") +
  ggplot2::xlim(0, 0.025) +
  ggplot2::labs(
    title = "The distribution of tree nltts of two replicate  posteriors",
    caption  = paste0("p value = ", low$p_value, ", figure_posterior_distribution_nltt_low")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()

















# Show posterior with high, median and high p value
high  <- df[which(df$p_value == max(df$p_value)), ]
high_filename <- paste0(posteriors_path, high$filename[1])
high_sti <- as.numeric(high$sti[1])
high_ai <- as.numeric(high$ai[1])
high_df <- wiritttea::collect_file_nltt_stats(high_filename)
high_nltts1 <- high_df[which(high_df$sti == high_sti & high_df$ai == high_ai & high_df$pi == 1), ]$nltt_stat
high_nltts2 <- high_df[which(high_df$sti == high_sti & high_df$ai == high_ai & high_df$pi == 2), ]$nltt_stat
df_high <- data.frame(
  pi = as.factor(c(rep(1, length(high_nltts1)), rep(2, length(high_nltts2)))),
  nltt  = c(high_nltts1, high_nltts2)
)

svg("~/figure_posterior_distribution_nltts_high.svg")
options(warn = 1) # Allow outliers not to be plotted
ggplot2::ggplot(
  stats::na.omit(df_high),
  ggplot2::aes(x = nltt, fill = pi)
) +
  ggplot2::geom_histogram(binwidth = 0.001, position = "identity", alpha = 0.25) +
  ggplot2::xlab("tree nltt") +
  ggplot2::ylab("Count") +
  ggplot2::xlim(0, 0.025) +
  ggplot2::labs(
    title = "The distribution of tree nltts of two replicate  posteriors",
    caption  = paste0("p value = ", high$p_value, ", figure_posterior_distribution_nltt_high")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()
