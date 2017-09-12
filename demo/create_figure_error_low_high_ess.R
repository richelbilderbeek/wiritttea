# Create figure 'figure_error_low_high_ess'
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/GitHubs/Peregrine", date, "")
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]
if (length(args) > 2) parameters_filename <- args[3]
if (length(args) > 3) esses_filename <- args[4]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))
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
       summarise(mean=mean(nltt_stat), sd=sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "ai", "pi", "mean", "sd")))
head(nltt_stat_means, n = 10)
nrow(nltt_stat_means)

print("Add mean duration of speciation to parameters")
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
n <- 1000000
df <- merge(x = parameters, y = dplyr::sample_n(nltt_stats, size = n), by = "filename", all = TRUE)
df_mean <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df)
names(df_mean)

# Calculate median ESS
names(esses)
median_ess <- median(na.omit(esses$treeLikelihood))

# Calculate the types
esses$ess_type <- esses$treeLikelihood > median_ess
# Convert: TRUE -> OK
esses$ess_type[ esses$ess_type == TRUE ] <- "High"
esses$ess_type[ esses$ess_type == FALSE ] <- "Low"
esses$ess_type <- as.factor(esses$ess_type)

# Merge with the ESSes
df <- merge(x = df, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)
df_mean <- merge(x = df_mean, y = esses, by = c("filename", "sti", "ai", "pi"), all = TRUE)

svg("~/figure_error_low_high_ess.svg")
ggplot2::ggplot(
  data = na.omit(df),
  ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = ess_type)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::labs(
      title = "The effect of a low and high ESS of tree likelihood on nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
      caption  = "figure_error_low_high_ess"
    ) +
    ggplot2::labs(fill = latex2exp::TeX("ESS tree\nlikelihood")) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_low_high_ess_mean.svg")
ggplot2::ggplot(
  data = na.omit(df_mean),
  ggplot2::aes(x = as.factor(scr), y = mean, fill = ess_type)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(
      title = "The effect of a low and high ESS of tree likelihood on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)",
      caption  = "figure_error_low_high_ess_mean"
    ) +
    ggplot2::labs(fill = latex2exp::TeX("ESS tree\nlikelihood")) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()




svg("~/figure_error_expected_mean_dur_spec_low_high_ess.svg")
set.seed(42)
n_sampled <- 5000
n_data_points <- nrow(na.omit(df))
nltt_stat_cutoff <- 0.12

options(warn = 1) # Allow points not to be plotted
ggplot2::ggplot(
  data = dplyr::sample_n(na.omit(df), size = n_sampled), # Out of 7M
  ggplot2::aes(x = mean_durspec, y = nltt_stat, color = ess_type)
) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
  ggplot2::geom_smooth(method = "lm") +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess") +
  ggplot2::scale_y_continuous(limits = c(0, nltt_stat_cutoff)) + # Will have some outliers unplotted
  ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
  ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "nLTT statistic\nfor different expected mean duration of speciation,\nfor ESSes",
    caption  = paste0("n = ", n_sampled, " / ", n_data_points, ", figure_error_expected_mean_dur_spec_ess_low_high")
  ) +
  ggplot2::labs(color = latex2exp::TeX("ESS type")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

options(warn = 2) # Be strict

dev.off()





svg("~/figure_error_expected_mean_dur_spec_mean_low_high_ess.svg")
options(warn = 1) # Allow points to fall off plot range

ggplot2::ggplot(
  data = na.omit(df_mean),
  ggplot2::aes(x = mean_durspec, y = mean, color = ess_type)
) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", size = 0.5) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    parse = TRUE) +
  #ggplot2::scale_y_continuous(limits = c(0, nltt_stat_cutoff)) + # Will have some outliers unplotted
  ggplot2::geom_smooth(method = "loess", size = 0.5) +
  ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
  ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
  ggplot2::labs(
    title = "Mean nLTT statistic\nfor different expected mean duration of speciation,\nfor tree likelihood ESSes aboven and below median",
    caption  = "figure_error_expected_mean_dur_spec_mean_low_high_ess"
  ) +
  ggplot2::labs(color = latex2exp::TeX("ESS type")) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))


options(warn = 2) # Be strict

dev.off()
