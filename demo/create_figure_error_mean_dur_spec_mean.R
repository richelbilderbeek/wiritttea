# Create 'figure_error_expected_mean_dur_spec_mean' (tailing mean: use the mean nLTT statistic)
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

print("Add mean duration of speciation to parameters")
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

# Take the mean of the nLTT stats
`%>%` <- dplyr::`%>%`
nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
       dplyr::summarise(mean = mean(nltt_stat), sd = stats::sd(nltt_stat))
nltt_stat_medians <- nltt_stats %>% dplyr::group_by(filename, sti, ai, pi) %>%
       dplyr::summarise(median = stats::median(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
testit::assert(all(names(nltt_stat_medians)
  == c("filename", "sti", "ai", "pi", "median")))

# Prepare parameters for merge
# parameters$filename <- row.names(parameters)
# parameters$filename <- as.factor(parameters$filename)

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df_means <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
df_medians <- merge(x = parameters, y = nltt_stat_medians, by = "filename", all = TRUE)

# Calculate mean BD error
testit::assert(max(stats::na.omit(df_means$scr)) == max(stats::na.omit(df_medians$scr)))
scr_bd <- max(stats::na.omit(df_means$scr))

mean_bd_error <- mean(stats::na.omit(df_means[ df_means$scr == scr_bd, ]$mean))
median_bd_error <- mean(stats::na.omit(df_medians[ df_medians$scr == scr_bd, ]$median))


print("Creating figure")

svg("~/figure_error_expected_mean_dur_spec_mean.svg")

options(warn = 1) # Allow points falling out of range


ggplot2::ggplot(
  data = stats::na.omit(df_means),
  ggplot2::aes(x = mean_durspec, y = mean)
) + ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "blue",
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
  ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
  ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
  ggplot2::xlab(latex2exp::TeX("Mean duration of speciation t_\\bar{ds}}")) +
  ggplot2::ylab(latex2exp::TeX("Mean nLTT statistic $\\bar{\\Delta_{nLTT}}$")) +
  ggplot2::labs(
    title = "Mean nLTT statistic for different duration of speciations",
    caption  = "figure_error_expected_mean_dur_spec_mean"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

options(warn = 2) # Be strict

dev.off()






svg("~/figure_error_expected_mean_dur_spec_median.svg")

options(warn = 1) # Allow points falling out of range
ggplot2::ggplot(
  data = stats::na.omit(df_medians),
  ggplot2::aes(x = mean_durspec, y = median)
) + ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", color = "blue", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\widetilde{\\Delta_{nLTT}}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    color = "blue",
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess", color = "red", size = 0.5, alpha = 0.25) +
  ggplot2::geom_hline(yintercept = mean_bd_error, linetype = "dotted") +
  ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
  ggplot2::xlab(latex2exp::TeX("Mean duration of speciation t_\\bar{ds}}")) +
  ggplot2::ylab(latex2exp::TeX("Median nLTT statistic $\\widetilde{\\Delta_{nLTT}}$")) +
  ggplot2::labs(
    title = "Median nLTT statistic for different duration of speciations",
    caption  = "figure_error_expected_mean_dur_spec_median"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

options(warn = 2) # Be strict

dev.off()

