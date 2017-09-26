# Analyse the nLTT stats
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
posterior_likelihoods_filename <- paste0("~/wirittte_data/posterior_likelihoods_", date, ".csv")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) posterior_likelihoods_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("posterior_likelihoods_filename:", posterior_likelihoods_filename))

if (!file.exists(posterior_likelihoods_filename)) {
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
  df_posterior_likelihoods <- wiritttea::collect_files_posterior_likelihoods(my_filenames)
  write.csv(df_posterior_likelihoods, posterior_likelihoods_filename)
}

# Read nLTT stats
posterior_likelihoods <- wiritttea::read_collected_posterior_likelihoods(posterior_likelihoods_filename)
head(posterior_likelihoods)
