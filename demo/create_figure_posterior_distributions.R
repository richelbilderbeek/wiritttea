# Create 'figure_posterior_distributions_likelihood' and 'figure_posterior_distributions_nltt'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
posterior_likelihoods_filename <- paste0("~/wirittte_data/posterior_likelihoods_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]

print(paste("posterior_likelihoods_filename:", posterior_likelihoods_filename))

if (!file.exists(posterior_likelihoods_filename)) {
  stop("File '", posterior_likelihoods_filename, "' not found, ",
    "please run analyse_posterior_likelihoods")
}

print("Read nLTT stats")
posterior_likelihoods_filename <- wiritttea::read_collected_posterior_likelihoods(posterior_likelihoods_filename)
names(nltt_stats)

testit::assert("pi" %in% names(nltt_stats))
library(dplyr)

df <- tidyr::spread(nltt_stats, pi, nltt_stat) %>% rename(pi1 = "1", pi2 = "2")

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

df3
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
  ggplot2::annotate("text", x = c(0.0, 0.125), y = 325, label = c("same", "different")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

dev.off()
