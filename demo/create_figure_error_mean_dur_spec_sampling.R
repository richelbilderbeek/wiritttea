# Create 'figure_error_expected_mean_dur_spec_sampling'
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

# Prepare parameters for merge
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

# Only select the columns we need
names(parameters)
parameters <- dplyr::select(parameters, c(filename, mean_durspec))

head(nltt_stats)
nltt_stats <- dplyr::select(nltt_stats, c(filename, sti, nltt_stat))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)

names(df)
head(df, n = 10)

print("Rename column")
df$sti <- plyr::revalue(df$sti, c("1" = "youngest", "2" = "oldest"))

print("Creating figure")

svg("~/figure_error_expected_mean_dur_spec_sampling.svg")
set.seed(42)
n_sampled <- 5000
n_data_points <- nrow(na.omit(df))
options(warn = 1) # Allow points not to be plotted
ggplot2::ggplot(
  data = dplyr::sample_n(na.omit(df), size = n_sampled), # Out of 7M
  ggplot2::aes(x = mean_durspec, y = nltt_stat, color = as.factor(sti))
) + ggplot2::geom_jitter(width = 0.01, alpha = 0.2) +
  ggplot2::geom_smooth(method = "lm", size = 0.5, alpha = 0.25) +
  ggpmisc::stat_poly_eq(
    formula = y ~ x,
    eq.with.lhs = paste(latex2exp::TeX("$\\Delta_{nLTT}$"), "~`=`~"),
    eq.x.rhs = latex2exp::TeX(" \\bar{t_{ds}}"),
    ggplot2::aes(label = paste(..eq.label.., ..adj.rr.label.., sep = "~~~~")),
    parse = TRUE) +
  ggplot2::geom_smooth(method = "loess", size = 0.5, alpha = 0.25) +
  ggplot2::scale_y_continuous(limits = c(0, 0.05)) + # Will have some outliers unplotted
  ggplot2::xlab(latex2exp::TeX(" t_\\bar{ds}} (million years)")) +
  ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
  ggplot2::labs(
    title = "nLTT statistic for different expected mean duration of speciation\nfor different sampling methods",
    caption  = paste0("n = ", n_sampled, " / ", n_data_points, ", figure_error_expected_mean_dur_spec_sampling")
  ) +
  ggplot2::labs(color = "Sampling") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()
