# Create 'figure_ess_expected_mean_dur_spec_alignment_length'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]
if (length(args) > 1) parameters_filename <- args[2]

print(paste("esses_filename:", esses_filename))
print(paste("parameters_filename:", parameters_filename))

if (!file.exists(parameters_filename)) {
  stop("Please run analyse_parameters")
}

if (!file.exists(esses_filename)) {
  stop("Please run analyse_esses")
}

# Read parameters and nLTT stats
parameters <- wiritttea::read_collected_parameters(parameters_filename)
esses <- wiritttea::read_collected_esses(esses_filename)

print("Add mean duration of speciation to parameters")
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
parameters <- dplyr::select(parameters, c(filename, mean_durspec, sequence_length))

head(esses)
esses <- dplyr::select(esses, c(filename, likelihood))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(esses))
df <- merge(x = parameters, y = esses, by = "filename", all = TRUE)

names(df)
head(df, n = 10)

print("Creating figure")

svg("~/figure_ess_expected_mean_dur_spec_alignment_length.svg")

ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = mean_durspec, y = likelihood, color = as.factor(sequence_length))
) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
  ggplot2::geom_smooth(method = "loess") +
  ggplot2::geom_smooth(method = "lm") +
  ggplot2::xlab("Expected mean duration of speciation (million years)") +
  ggplot2::ylab("ESS") +
  ggplot2::labs(
    title = paste0("ESS for different expected mean duration of speciation"),
    caption  = "figure_ess_mean_dur_spec_alignment_length"
  ) +
  ggplot2::labs(color = "DNA\nalignment\nlength\n(base pairs)") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


dev.off()
