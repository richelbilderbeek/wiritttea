# Create 'figure_error', a global and coarse overview of the nLTT statistic distribution
# of all simulations
library(wiritttea)
options(warn = 2) # Be strict

date <- "stub"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) date <- args[1]

nltt_stats_filename <- paste0("~/wirittte_data/nltt_stats_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

print(paste("nltt_stats_filename:", nltt_stats_filename))
print(paste("parameters_filename:", parameters_filename))

if (!file.exists(parameters_filename)) {
  stop(
    "File '", parameters_filename, "' not found, ",
    "please run analyse_parameters"
  )
}

if (!file.exists(nltt_stats_filename)) {
  stop("File '", nltt_stats_filename, "' not found, ",
    "please run analyse_nltt_stats")
}

print("Read parameters")
parameters <- wiritttea::read_collected_parameters(parameters_filename)
names(parameters)


print("Add mean duration of speciation to parameters")
parameters$mean_durspec <- PBD::pbd_mean_durspecs(
  eris = parameters$eri,
  scrs = parameters$scr,
  siris = parameters$siri
)

print("Prepare parameters for merge")
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)
parameters <- subset(parameters, select = c(filename, mean_durspec) )

print("Read nLTT stats")
nltt_stats <- wiritttea::read_collected_nltt_stats(nltt_stats_filename, burn_in_fraction = 0.2)

print("Prepare nLTT stats for merge")
nltt_stats <- subset(nltt_stats, select = c(filename, nltt_stat) )
# head(nltt_stats)

print("Connect the nLTT stats and parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(nltt_stats))
df <- merge(x = parameters, y = nltt_stats, by = "filename", all = TRUE)
names(df)
head(df, n = 10)

df <- stats::na.omit(df)

my_colors <- hsv(scales::rescale(sort(unique(df$mean_durspec)), to = c(0.0, 5.0 / 6.0)))

print("Creating figures")

cut_x <- 0.05 # nLTT statistic value at which head and teail are seperated

svg("~/figure_error.svg")
ggplot2::ggplot(
  data = df,
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("$\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error.svg"
  #) +
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()



svg("~/figure_error_head.svg")
ggplot2::ggplot(
  data = df[df$nltt_stat < 0.05, ],
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::coord_cartesian(xlim = c(0.0, cut_x)) +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("$\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error_head.svg"
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

svg("~/figure_error_tail.svg")
ggplot2::ggplot(
  data = df[df$nltt_stat > 0.05, ],
  ggplot2::aes(x = nltt_stat, fill = factor(mean_durspec))
) +
  ggplot2::geom_histogram(binwidth = 0.001) +
  ggplot2::scale_fill_manual(values = my_colors) +
  ggplot2::geom_vline(xintercept = cut_x, linetype = "dotted") +
  ggplot2::coord_cartesian(xlim = c(cut_x, 0.35)) +
  ggplot2::labs(
    title = "nLTT statistic distribution",
    x = latex2exp::TeX("$\\Delta_{nLTT}$"),
    y = "Count",
    caption = "figure_error_tail.svg"
  ) + ggplot2::guides(fill = FALSE) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
dev.off()

