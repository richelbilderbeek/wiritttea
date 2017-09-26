# Analyse the posterior crown ages
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
posterior_crown_ages_filename <- paste0("~/wirittte_data/posterior_crown_ages_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) posterior_crown_ages_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("posterior_crown_ages_filename:", posterior_crown_ages_filename))

if (!file.exists(posterior_crown_ages_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  df_posterior_crown_ages <- wiritttea::collect_files_posterior_crown_ages(my_filenames, verbose = TRUE)
  write.csv(df_posterior_crown_ages, posterior_crown_ages_filename)
}

# Read nLTT stats
posterior_crown_ages <- wiritttea::read_collected_posterior_crown_ages(posterior_crown_ages_filename)
head(posterior_crown_ages)
