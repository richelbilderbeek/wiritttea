# Create 'figure_posterior_distributions_likelihood' and 'figure_posterior_distributions_nltt'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
posterior_likelihoods_filename <- paste0("~/wirittte_data/posterior_likelihoods_", date, ".csv")
posteriors_path <- paste0("~/wirittte_data/", date, "/")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]

print(paste("posterior_likelihoods_filename:", posterior_likelihoods_filename))

if (!file.exists(posterior_likelihoods_filename)) {
  stop("File '", posterior_likelihoods_filename, "' not found, ",
    "please run analyse_posterior_likelihoods")
}

print("Read posterior likelihoods")
posterior_likelihoods <- wiritttea::read_collected_posterior_likelihoods(posterior_likelihoods_filename)

print("Determine sample size")
n_sampled <- 500000
print(paste0("Using a sample of ", n_sampled, " of ", nrow(posterior_likelihoods), " observations"))

print("Sample some of the likelihoods")
library(dplyr)
set.seed(42)
some_posterior_likelihoods <- dplyr::sample_n(posterior_likelihoods, size = n_sampled)
head(some_posterior_likelihoods)

print("Split posterior likelihoods per posterior index")
testit::assert("pi" %in% names(posterior_likelihoods))
df <- tidyr::spread(some_posterior_likelihoods, pi, likelihood) %>% rename(pi1 = "1", pi2 = "2")

print("Remove NA column")
df <- dplyr::select(df, -starts_with("<NA>"))
testit::assert(names(df) == c("filename", "sti", "ai", "si", "pi1", "pi2"))

print("Remove NAs")
df <- na.omit(df)
nrow(df)

print("Group")
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
        na.action = na.omit
      )$p.value,
      error = function(cond) {} # nolint
    )
  p
}

df <- df %>% summarize(p_value = safe_mann_whitney(pi1, pi2))

head(df)
names(df)

svg("~/figure_posterior_distribution_likelihoods.svg")
ggplot2::ggplot(
  na.omit(df),
  ggplot2::aes(x = p_value, na.omit = TRUE)
) +
  ggplot2::geom_histogram(binwidth = 0.01) +
  ggplot2::geom_vline(xintercept = 0.05, linetype = "dotted") +
  ggplot2::xlab("p value") +
  ggplot2::ylab("Count") +
  ggplot2::labs(
    title = "The distribution of p values of Mann-Whitney tests\nbetween posterior likelihoods",
    caption  = "'figure_posterior_distribution_likelihood'"
  ) +
  ggplot2::annotate("text", x = c(0.0, 0.125), y = 1450, label = c("different", "same")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()












# Show posterior with low, median and high p value
low  <- df[which(df$p_value == min(   df$p_value)), ]
low_filename <- paste0(posteriors_path, "/", low$filename[1])
low_sti <- as.numeric(low$sti[1])
low_ai <- as.numeric(low$ai[1])
low_file <- wiritttes::read_file(low_filename)
low_likelihoods1 <- wiritttes::get_posterior(low_file, sti = low_sti, ai = low_ai, pi = 1)$estimates$likelihood
low_likelihoods2 <- wiritttes::get_posterior(low_file, sti = low_sti, ai = low_ai, pi = 2)$estimates$likelihood
df_low <- data.frame(
  pi = as.factor(c(rep(1, length(low_likelihoods1)), rep(2, length(low_likelihoods2)))),
  likelihood  = c(low_likelihoods1, low_likelihoods2)
)

svg("~/figure_posterior_distribution_likelihoods_low.svg")
options(warn = 1) # Allow outliers not to be plotted
ggplot2::ggplot(
  na.omit(df_low),
  ggplot2::aes(x = likelihood, fill = pi)
) +
  ggplot2::geom_histogram(binwidth = 0.5, position = "identity", alpha = 0.25) +
  ggplot2::xlab("tree likelihood") +
  ggplot2::ylab("Count") +
  ggplot2::xlim(-59330,-59310) +
  ggplot2::labs(
    title = "The distribution of tree likelihoods of two replicate  posteriors",
    caption  = paste0("p value = ", low$p_value, ", figure_posterior_distribution_likelihood_low")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()






high <- df[which(df$p_value == max(   df$p_value)), ]

high_filename <- paste0(posteriors_path, "/", high$filename[1])
high_sti <- as.numeric(high$sti[1])
high_ai <- as.numeric(high$ai[1])
high_file <- wiritttes::read_file(high_filename)
high_likelihoods1 <- wiritttes::get_posterior(high_file, sti = high_sti, ai = high_ai, pi = 1)$estimates$likelihood
high_likelihoods2 <- wiritttes::get_posterior(high_file, sti = high_sti, ai = high_ai, pi = 2)$estimates$likelihood
df_high <- data.frame(
  pi = as.factor(c(rep(1, length(high_likelihoods1)), rep(2, length(high_likelihoods2)))),
  likelihood  = c(high_likelihoods1, high_likelihoods2)
)

svg("~/figure_posterior_distribution_likelihoods_high.svg")
options(warn = 1) # Allow outliers not to be plotted
ggplot2::ggplot(
  na.omit(df_high),
  ggplot2::aes(x = likelihood, fill = pi)
) +
  ggplot2::geom_histogram(position = "identity", alpha = 0.25) +
  ggplot2::xlab("tree likelihood") +
  ggplot2::ylab("Count") +
  #ggplot2::xlim(-59330,-59310) +
  ggplot2::labs(
    title = "The distribution of tree likelihoods of two replicate posteriors",
    caption  = paste0("p value = ", high$p_value, ", figure_posterior_distribution_likelihood_high")
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()

