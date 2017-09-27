# Collect the alignments' qualities
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/alignments_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/alignments_stub.csv'")
}

#args <- c("/home/richel/wirittte_data/20170926", "~/alignments_20170926.csv")

path_data <- args[1]
alignments_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignments_filename:", alignments_filename))

my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)
df <- wiritttea::collect_files_alignments(my_filenames, show_progress = TRUE)
write.csv(df, alignments_filename)
