# Create 'figure_error_alignment_length_mean'
#   and 'figure_error_alignment_length_median'
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
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)
esses <- wiritttea::read_collected_esses(esses_filename)

# Take the mean of the nLTT stats
library(dplyr)
nltt_stat_means <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(mean = mean(nltt_stat), sd = sd(nltt_stat))
nltt_stat_medians <- nltt_stats %>% group_by(filename, sti, ai, pi) %>%
       summarise(median = median(nltt_stat))

testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
testit::assert(all(names(nltt_stat_medians)
  == c("filename", "sti", "ai", "pi", "median")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df_means <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
df_medians <- merge(x = parameters, y = nltt_stat_medians, by = "filename", all = TRUE)

# Merge with the ESSes
df_means <- merge(x = df_means, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)
df_medians <- merge(x = df_medians, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)


print("Creating figure")

svg("~/figure_error_alignment_length_mean.svg")

ggplot2::ggplot(
  data = stats::na.omit(df_means),
  ggplot2::aes(x = as.factor(scr), y = mean, fill = as.factor(sequence_length))
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab(latex2exp::TeX("Speciation completion rate $\\lambda$")) +
    ggplot2::ylab(latex2exp::TeX("Mean nLTT statistics, $\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      fill = latex2exp::TeX("Sequence\nlength $l_a$"),
      title = "The effect of alignment length on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
      caption  = "figure_error_alignment_length_mean"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_alignment_length_median.svg")

ggplot2::ggplot(
  data = stats::na.omit(df_medians),
  ggplot2::aes(x = as.factor(scr), y = median, fill = as.factor(sequence_length))
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab(latex2exp::TeX("Speciation completion rate $\\lambda$")) +
    ggplot2::ylab(latex2exp::TeX("Median nLTT statistics, $\\widetilde{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      fill = latex2exp::TeX("Sequence\nlength $l_a$"),
      title = "The effect of alignment length on median nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
      caption  = "figure_error_alignment_length_median"
    ) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()
