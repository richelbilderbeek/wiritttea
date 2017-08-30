# Create 'figure_error_expected_mean_dur_spec_mean_alignment_length'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]
if (length(args) > 1) parameters_filename <- args[2]

print(paste("nltt_stats_filename:", nltt_stats_filename))
print(paste("parameters_filename:", parameters_filename))

if (!file.exists(parameters_filename)) {
  stop("Please run analyse_parameters")
}

if (!file.exists(nltt_stats_filename)) {
  stop("Please run analyse_nltt_stats")
}

# Read parameters and nLTT stats
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

# Add mean duration of speciation to parameters
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

# Take the mean of the nLTT stats
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

# Calculate mean BD error
scr_bd <- max(na.omit(df$scr))
mean_bd_error_1000  <- mean(na.omit(df[ df$scr == scr_bd & df$sequence_length == 1000, ]$mean))
mean_bd_error_10000 <- mean(na.omit(df[ df$scr == scr_bd & df$sequence_length == 10000, ]$mean))


print("Creating figure")

svg("~/figure_error_expected_mean_dur_spec_mean_alignment_length.svg")
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = mean_durspec, y = mean, color = as.factor(sequence_length))
) + ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "loess", size = 0.5) +
  ggplot2::geom_smooth(method = "lm", size = 0.5) +
  ggplot2::geom_hline(yintercept = mean_bd_error_1000, linetype = "dashed", color = scales::hue_pal()(2)[1]) +
  ggplot2::geom_hline(yintercept = mean_bd_error_10000, linetype = "dashed", color = scales::hue_pal()(2)[2]) +
  ggplot2::xlab("Expected mean duration of speciation (million years)") +
  ggplot2::ylab("Mean nLTT statistic") +
  ggplot2::labs(
    title = "Mean nLTT statistic for different duration of speciations",
    caption  = "figure_error_expected_mean_dur_spec_mean_alignment_length"
  ) +
  ggplot2::labs(color = "DNA\nalignment\nlength\n(base pairs)") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


dev.off()
