# Create 'figure_posterior_distributions_likelihood' and 'figure_posterior_distributions_nltt'
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

testit::assert("pi" %in% names(nltt_stats))
library(dplyr)

df <- tidyr::spread(nltt_stats, pi, nltt_stat) %>% rename(pi1 = "1", pi2 = "2")

head(df)
df2 <- dplyr::group_by(.data = df, sti, ai)
head(df2)

safe_mann_whitney <- function(pi1, pi2)
{
  tryCatch(
      stats::wilcox.test(
        pi1,
        pi2,
        correct = FALSE,
        exact = FALSE, # cannot compute exact p-value with ties
        na.action = na.omit
      )$p.value,
      error = function(cond) { NA }
    )
}

df3 <- df2 %>% summarize(x = safe_mann_whitney(pi1, pi2))

df3 <- df2 %>% summarize(x = stats::wilcox.test(
        pi1,
        pi2,
        correct = FALSE,
        exact = FALSE, # cannot compute exact p-value with ties
        na.action = na.omit
      )$p.value)
head(df3)

getOption("na.action")

#head(reshape2::dcast(nltt_stats, value,value.var = nltt_stat, id.var = "pi",  ~ ai ~ sti))
head(tidyr::separate(nltt_stats, col = pi, into = c("pi1", "pi2")))

testit::assert("pi1" %in% names(nltt_stats))
testit::assert("pi2" %in% names(nltt_stats))
