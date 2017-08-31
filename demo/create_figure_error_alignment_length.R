# Create 'figure_error_alignment_length'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) nltt_stats_filename <- args[1]
if (length(args) > 1) parameters_filename <- args[2]
if (length(args) > 2) esses_filename <- args[3]

print(paste("nltt_stats_filename:", nltt_stats_filename))
print(paste("parameters_filename:", parameters_filename))
print(paste("esses_filename:", esses_filename))

if (!file.exists(parameters_filename)) {
  stop("Please run analyse_parameters")
}

if (!file.exists(nltt_stats_filename)) {
  stop("Please run analyse_nltt_stats")
}

if (!file.exists(esses_filename)) {
  stop("Please run analyse_esses")
}

# Read parameters and nLTT stats
parameters <- wiritttea::read_collected_parameters(parameters_filename)
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename)

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Select only those columns that we need
names(parameters)
parameters <- dplyr::select(parameters, c(sirg, scr, erg, sequence_length, filename))
names(nltt_stats)
nltt_stats <- dplyr::select(nltt_stats, c(filename, nltt_stat))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

head(df)

print("Creating figure")

svg("~/figure_error_alignment_length.svg")
n_samples <- 342800
n_data <- nrow(na.omit(df))

ggplot2::ggplot(
  data = dplyr::sample_n(na.omit(df), n_samples),
  ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = as.factor(sequence_length))
) + ggplot2::geom_boxplot(outlier.alpha = 0.1, outlier.size = 0.5) +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab("Speciation completion rate (probability per lineage per million years)") +
    ggplot2::ylab("nLTT statistic") +
    ggplot2::labs(
      title = paste0(
        "The effect of alignment length on nLTT statistic for\n",
        "different speciation completion rates (x axis boxplot),\n",
        "speciation initiation rates (columns)\n",
        "and extinction rates (rows) (n = ", n_samples, "/", n_data, ")"
      ),
      fill = "Sequence\nlength (bp)",
      caption  = "figure_error_alignment_length_mean"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
