# Create figure 170
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/GitHubs/Peregrine", date)
nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) nltt_stats_filename <- args[2]
if (length(args) > 2) parameters_filename <- args[3]

print(paste("path_data:", path_data))
print(paste("nltt_stats_filename:", nltt_stats_filename))

if (!file.exists(parameters_filename)) {
  stop("Please run analyse_parameters")
}

if (!file.exists(nltt_stats_filename)) {
  stop("Please run analyse_nltt_stats")
}

print("Read parameters")
parameters <- wiritttea::read_collected_parameters(parameters_filename)

print("Add mean duration of speciation to parameters")
#parameters$mean_durspec <- PBD::pbd_mean_durspecs(
#  eris = parameters$eri,
#  scrs = parameters$scr,
#  siris = parameters$siri
#)

# print("Prepare parameters for merge")
# parameters$filename <- row.names(parameters)
# parameters$filename <- as.factor(parameters$filename)
# names(parameters)

print("Select only those columns needed")
parameters <- dplyr::select(parameters, c(filename, sirg, scr, erg))
#parameters <- dplyr::select(parameters, c(filename, sirg, scr, erg, mean_durspec))

print("Read nLTT stats")
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)

print("Use only half of the nLTT stats, due to memory")
n_nltt_stats_all <- nrow(nltt_stats)
n_nltt_stats <- n_nltt_stats_all / 2

print("Combine raw nLTT with parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
set.seed(42)
df <- merge(x = parameters, y = dplyr::sample_n(nltt_stats, size = n_nltt_stats), by = "filename", all = TRUE)

print("Take the mean of the nLTT stats")
`%>%` <- dplyr::`%>%`
nltt_stat_means <- nltt_stats %>% dplyr::group_by(filename, sti) %>%
       dplyr::summarise(mean = mean(nltt_stat), sd = stats::sd(nltt_stat))
testit::assert(all(names(nltt_stat_means)
  == c("filename", "sti", "mean", "sd")))

# Connect the mean nLTT stats and parameters
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stat_means))
df_mean <- merge(x = parameters, y = nltt_stat_means, by = "filename", all = TRUE)
names(df_mean)

print("Rename column")
df$sti <- plyr::revalue(df$sti, c("1" = "youngest", "2" = "oldest"))
df_mean$sti <- plyr::revalue(df_mean$sti, c("1" = "youngest", "2" = "oldest"))

# Plotting parameters
nltt_stat_cutoff <- 0.03
sample_size <- 500000

svg("~/figure_error_sampling_representative.svg")
ggplot2::ggplot(
  data = dplyr::sample_n(stats::na.omit(df), size = sample_size),
  ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = sti)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::geom_hline(yintercept = nltt_stat_cutoff, linetype = "dotted") +
    ggplot2::labs(fill = "Sampling") +
    ggplot2::labs(caption = paste0("(n = ", sample_size,"/", n_nltt_stats_all,"), figure_error_sampling_representative")) +
    ggplot2::ggtitle("The effect of sampling on nLTT statistic values for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_sampling_representative_zoom.svg")
set.seed(42)
options(warn = 1) # Allow points not to be plotted
ggplot2::ggplot(
  data = dplyr::sample_n(stats::na.omit(df), size = sample_size),
  ggplot2::aes(x = as.factor(scr), y = nltt_stat, fill = sti)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::scale_y_continuous(limits = c(0.0, nltt_stat_cutoff)) +
    ggplot2::geom_hline(yintercept = nltt_stat_cutoff, linetype = "dotted") +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\Delta_{nLTT}$")) +
    ggplot2::labs(fill = "Sampling") +
    ggplot2::labs(caption = paste0("(n = ", sample_size,"/", n_nltt_stats_all,"), figure_error_sampling_representative_zoom")) +
    ggplot2::ggtitle("The effect of sampling on nLTT statistic values for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()

svg("~/figure_error_sampling_representative_mean.svg")
ggplot2::ggplot(
  data = stats::na.omit(df_mean),
  ggplot2::aes(x = as.factor(scr), y = mean, fill = sti)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::geom_hline(yintercept = nltt_stat_cutoff, linetype = "dotted") +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(fill = "Sampling") +
    ggplot2::labs(caption = "figure_error_sampling_representative_mean") +
    ggplot2::ggtitle("The effect of sampling on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_sampling_representative_mean_zoom.svg")
options(warn = 1) # Allow points not to be plotted
ggplot2::ggplot(
  data = stats::na.omit(df_mean),
  ggplot2::aes(x = as.factor(scr), y = mean, fill = sti)
) + ggplot2::geom_boxplot() +
    ggplot2::facet_grid(erg ~ sirg) +
    ggplot2::scale_y_continuous(limits = c(0.0, nltt_stat_cutoff)) +
    ggplot2::geom_hline(yintercept = nltt_stat_cutoff, linetype = "dotted") +
    ggplot2::xlab(latex2exp::TeX("$\\lambda$ (probability per lineage per million years)")) +
    ggplot2::ylab(latex2exp::TeX("$\\bar{\\Delta_{nLTT}}$")) +
    ggplot2::labs(fill = "Sampling") +
    ggplot2::labs(caption = "figure_error_sampling_representative_mean_zoom") +
    ggplot2::ggtitle("The effect of sampling on mean nLTT statistic for\ndifferent speciation completion rates (x axis boxplot),\nspeciation initiation rates (columns)\nand extinction rates (rows)") +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
options(warn = 2) # Be strict
dev.off()
