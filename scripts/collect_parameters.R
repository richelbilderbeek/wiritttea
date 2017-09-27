# Collects the parameters used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/parameters_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/parameters_stub.csv'")
}

path_data <- args[1]
parameters_filename <- args[2]

# Collect all parameters in a single file
# Will overwrite
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
write.csv(wiritttea::collect_files_parameters(filenames = my_filenames), parameters_filename)
