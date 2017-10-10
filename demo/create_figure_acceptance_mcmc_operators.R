# # Analyse the BEAST2 operators, as found in the .xml.state files
# library(wiritttea)
# options(warn = 2) # Be strict
# date <- "20170710"
# operators_filename <- paste0("~/GitHubs/wirittte_data/operators_", date, ".csv")
#
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) > 0) operators_filename <- args[1]
#
# print(paste("operators_filename:", operators_filename))
#
# if (!file.exists(operators_filename)) {
#   stop("File is absent, please run 'analyse_operators.R'")
# }
#
# print("Load operators")
# df_operators <- wiritttea::read_collected_operators(operators_filename)
#
# wiritttea::create_figure_acceptance_mcmc_operators(
#   df_operators = df_operators,
#   svg_filename = "~/figure_acceptance_mcmc_operators.svg"
# )
