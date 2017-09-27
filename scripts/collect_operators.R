# Collects the operators used in all .RDa files in one file
library(wiritttea)
options(warn = 2)

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/operators_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two operators: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/operators_stub.csv'")
}

path_data <- args[1]
operators_filename <- args[2]

print("Collecting .xml.state files")
my_filenames <- list.files(path_data, pattern = ".*\\.xml\\.state", full.names = TRUE)

print("Collecting operators")
df_operators <- wiritttea::collect_files_operators(filenames = my_filenames, show_progress = FALSE)

print("Saving operators")
write.csv(df_operators, operators_filename)
