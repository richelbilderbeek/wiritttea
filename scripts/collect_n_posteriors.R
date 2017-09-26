# Analyse the number of posteriors
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/n_posteriors_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/parameters_stub.csv'")
}

path_data <- args[1]
n_posteriors_filename <- args[2]

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) n_posteriors_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("n_posteriors_filename:", n_posteriors_filename))

print("Collecting .RDa files")
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

print("Collecting # posteriors")
df_n_posteriors <- wiritttea::collect_files_n_posteriors(filenames = my_filenames)

print("Saving # posteriors")
write.csv(df_n_posteriors, n_posteriors_filename)
