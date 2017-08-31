# Create 'figure_error_alignment_length_mean'
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
esses <- wiritttea::read_collected_esses(esses_filename)

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


# Merge with the ESSes
df <- merge(x = df, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)

head(df)

print("Creating figure")

svg("~/figure_error_alignment_length_mean.svg")

ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = as.factor(scr), y = mean, fill = as.factor(sequence_length))
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab("Speciation completion rate (probability per lineage per million years)") +
    ggplot2::ylab("Mean nLTT statistics") +
    ggplot2::labs(
      fill = "Sequence/nlength (bp)",
      title = "The effect of alignment length on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
      caption  = "figure_error_alignment_length_mean"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
