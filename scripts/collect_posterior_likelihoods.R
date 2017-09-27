# Collects the posterior_likelihoods used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/posterior_likelihoods_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two posterior_likelihoods: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/posterior_likelihoods_stub.csv'")
}

path_data <- args[1]
posterior_likelihoods_filename <- args[2]

# Do it
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
df_posterior_likelihoods <- wiritttea::collect_files_posterior_likelihoods(my_filenames)
write.csv(df_posterior_likelihoods, posterior_likelihoods_filename)
