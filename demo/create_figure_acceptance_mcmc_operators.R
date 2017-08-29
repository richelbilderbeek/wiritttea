# Analyse the BEAST2 operators, as found in the .xml.state files
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
operators_filename <- paste0("~/GitHubs/wirittte_data/operators_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) operators_filename <- args[1]

print(paste("operators_filename:", operators_filename))

if (!file.exists(operators_filename)) {
  stop("File is absent, please run 'analyse_operators.R'")
}

print("Load operators")
df_operators <- wiritttea::read_collected_operators(operators_filename)


svg("~/figure_acceptance_mcmc_operators.svg")

ggplot2::ggplot(
  na.omit(df_operators),
  ggplot2::aes(x = operator, y = p, fill = operator)
) +
  ggplot2::geom_boxplot() +
  ggplot2::labs(
    title = "Operator acceptances",
    x = "Operator",
    y = "Acceptance",
    caption = "figure_acceptance_mcmc_operators"
  ) +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
  ggplot2::geom_hline(yintercept = 0.234, linetype = "dashed")

dev.off()

