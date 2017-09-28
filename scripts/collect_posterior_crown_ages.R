# Collects the posterior_crown_ages used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/posterior_crown_ages_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two posterior_crown_ages: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/posterior_crown_ages_stub.csv'")
}

path_data <- args[1]
posterior_crown_ages_filename <- args[2]

# Do it
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
df_posterior_crown_ages <- wiritttea::collect_files_pstr_crown_ages(my_filenames, verbose = TRUE)
write.csv(df_posterior_crown_ages, posterior_crown_ages_filename)
