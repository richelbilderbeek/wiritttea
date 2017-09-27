# Collect the alignment's DMIDs
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/strees_identical_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/strees_identical_stub.csv'")
}

#args <- c("/home/richel/wirittte_data/20170926", "~/strees_20170926.csv")

path_data <- args[1]
strees_identical_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("strees_identical_filename:", strees_identical_filename))

print("Collecting .RDa files")
my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

print("Collecting strees_identical")
df_strees_identical <- wiritttea::collect_files_strees_identical(filenames = my_filenames)

print("Saving strees_identical")
write.csv(df_strees_identical, strees_identical_filename)
