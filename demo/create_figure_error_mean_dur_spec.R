# Create 'figure_error_expected_mean_dur_spec'
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

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Only select the columns we need
names(parameters)
parameters <- dplyr::select(parameters, c(filename, mean_durspec, scr))

head(nltt_stats)
nltt_stats <- dplyr::select(nltt_stats, c(filename, nltt_stat))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

names(df)
head(df, n = 10)

# Calculate mean BD error
scr_bd <- max(na.omit(df$scr))
mean_bd_error <- mean(na.omit(df[ df$scr == scr_bd, ]$nltt_stat))


print("Creating figure")

svg("~/figure_error_expected_mean_dur_spec.svg")
n_sampled <- 10000
n_data_points <- nrow(na.omit(df))
ggplot2::ggplot(
  data = dplyr::sample_n(na.omit(df), size = n_sampled), # Out of 7M
  ggplot2::aes(x = mean_durspec, y = nltt_stat)
) + ggplot2::geom_jitter(width = 0.01, alpha = 0.01) +
  # ggplot2::geom_smooth(method = "loess") +
  ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
  ggplot2::xlab("Expected mean duration of speciation (million years)") +
  ggplot2::ylab("nLTT statistic") +
  ggplot2::labs(
    title = paste0("nLTT statistic for different expected mean duration of speciation (n = ", n_sampled, " / ", n_data_points, ")"),
    caption  = "figure_error_expected_mean_dur_spec"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


dev.off()
