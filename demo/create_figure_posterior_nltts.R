# Create 'figure_posterior_distributions_nltts'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]

print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run analyse_nltt_stats")
}

print("Read nLTT stats")
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)
names(nltt_stats)

dplyr::sample_n(nltt_stats, size = 100)

testit::assert("pi" %in% names(nltt_stats))
library(dplyr)

print("Split nLTT stats of first and second posterior")
df <- tidyr::spread(nltt_stats, pi, nltt_stat) %>% rename(pi1 = "1", pi2 = "2")

print("Remove NA column")
df <- dplyr::select(df, -starts_with("<NA>"))
testit::assert(names(df) == c("filename", "sti", "ai", "si", "pi1", "pi2"))

print("Remove NAs")
df <- na.omit(df)

head(df)

df2 <- dplyr::group_by(.data = df, filename, sti, ai)
head(df2)

safe_mann_whitney <- function(pi1, pi2)
{
  p <- NA
  tryCatch(
      p <- stats::wilcox.test(
        pi1,
        pi2,
        correct = FALSE,
        exact = FALSE, # cannot compute exact p-value with ties
        na.action = na.omit
      )$p.value,
      error = function(cond) {} # nolint
    )
  p
}

df3 <- df2 %>% summarize(x = safe_mann_whitney(pi1, pi2))

head(df3)
names(df3)
hist(df3$x)

svg("~/figure_posterior_distribution_nltt.svg")
ggplot2::ggplot(
  na.omit(df3),
  ggplot2::aes(x = x, na.omit = TRUE)
) +
  ggplot2::geom_histogram(binwidth = 0.01) +
  ggplot2::geom_vline(xintercept = 0.05, linetype = "dotted") +
  ggplot2::xlab("p value") +
  ggplot2::ylab("Count") +
  ggplot2::labs(
    title = "The distribution of p values of Mann-Whitney tests\nbetween posterior nLTT statistics",
    caption  = "'figure_posterior_distribution_nltt'"
  ) +
  ggplot2::annotate("text", x = c(0.0, 0.125), y = 325, label = c("different", "same")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

dev.off()
