# Create 'figure_ess_distribution'
options(warn = 2) # Be strict
date <- "20170710"
esses_filename <- paste0("~/GitHubs/wirittte_data/esses_", date, ".csv")
parameters_filename <- paste0("~/GitHubs/wirittte_data/parameters_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) esses_filename <- args[1]
if (length(args) > 1) parameters_filename <- args[2]

if (!file.exists(esses_filename)) {
  stop("esses_filename absent, please run analyse_esses.R")
}

if (!file.exists(parameters_filename)) {
  stop("parameters_filename absent, please run analyse_parameters")
}

print("Read parameters and ESSes")
df_esses <- wiritttea::read_collected_esses(esses_filename)
parameters <- wiritttea::read_collected_parameters(parameters_filename)

print("Prepare parameters for merge")
parameters$filename <- row.names(parameters)
parameters$filename <- as.factor(parameters$filename)

head(df)

# Melt data, convert to long form
df_esses_long <- reshape2::melt(df_esses,
  id = c("filename", "sti", "ai", "pi")
)
testit::assert(is.factor(df_esses_long$variable))

df_esses_long <- dplyr::rename(df_esses_long, parameter = variable)
df_esses_long <- dplyr::rename(df_esses_long, ess = value)
head(df_esses_long)

print("Connect the ESSes and parameters")
testit::assert("filename" %in% names(parameters))
testit::assert("filename" %in% names(df_esses))
df <- merge(x = parameters, y = df_esses_long, by = "filename", all = TRUE)
head(df)

svg("~/figure_ess_distribution.svg")

ggplot2::ggplot(
  data = stats::na.omit(df),
  ggplot2::aes(x = ess, fill = parameter)) +
  ggplot2::geom_histogram(alpha = 0.5, position = "identity", binwidth = 10) +
  ggplot2::facet_grid(erg ~ scr) +
  ggplot2::labs(
    title =
      "The distribution of Effective Sample Sizes per parameter estimate\nfor different speciation completion (columns) and extinction rates",
    x = "Effective Sample Size",
    y = "Count",
    caption = "figure_ess_distribution.svg"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::geom_vline(xintercept = 200, linetype = "dotted")

dev.off()

svg("~/figure_ess_distribution_likelihood.svg")

ggplot2::ggplot(
  data = df[ df$parameter == "likelihood", ],
  ggplot2::aes(x = ess)) +
  ggplot2::geom_histogram(alpha = 0.5, position = "identity", binwidth = 50, na.rm = TRUE, color = "black") +
  ggplot2::facet_grid(erg ~ scr) +
  ggplot2::coord_cartesian(ylim = c(0, 100)) +
  ggplot2::labs(
    title = "Tree likelihood ESS distribution",
    x = "Tree likelihood ESS",
    y = "Count",
    caption = "figure_ess_distribution_likelihood.svg"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::geom_vline(xintercept = 200, linetype = "dotted")

dev.off()
