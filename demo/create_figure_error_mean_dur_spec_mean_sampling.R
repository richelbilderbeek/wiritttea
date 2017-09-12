# Create 'figure_error_expected_mean_dur_spec_mean_sampling'
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
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)

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

# Only select the columns we need
names(parameters)
parameters <- dplyr::select(parameters, c(filename, mean_durspec))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

print("Rename column")
df$sti <- plyr::revalue(df$sti, c("1" = "youngest", "2" = "oldest"))

print("Creating figure")

svg("~/figure_error_expected_mean_dur_spec_mean_sampling.svg")

options(warn = 1) # Allow points to fall off plot range

ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = mean_durspec, y = mean, color = sti)
) + ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    parse = TRUE) +
  ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
  ggplot2::geom_smooth(method = "loess", size = 0.5, alpha = 0.25) +
  ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
  ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
  ggplot2::labs(
    title = "Mean nLTT statistic for different duration of speciations\nfor different sampling methods",
    caption  = "figure_error_expected_mean_dur_spec_mean_sampling"
  ) +
  ggplot2::labs(color = "Sampling") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

options(warn = 2) # Be strict

dev.off()
