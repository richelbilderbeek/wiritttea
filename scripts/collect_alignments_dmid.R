# Collect the alignment's DMIDs
library(wiritttea)
options(warn = 2) # Be strict

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder as a first argument, e.g. '~/wirittte_data/stub'")
}
if (length(args) == 1) {
  stop("Supply a target filename as a second argument, e.g. '~/alignment_dmid_stub.csv'")
}
if (length(args) != 2) {
  stop("Supply two parameters: a source folder and a target filename, ",
    "e.g. '~/wirittte_data/stub ~/alignment_dmid_stub.csv'")
}

#args <- c("/home/richel/wirittte_data/20170926", "~/alignment_dmid_20170926.csv")

path_data <- args[1]
alignment_dmid_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("alignment_dmid_filename:", alignment_dmid_filename))

my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

df <- collect_files_alignments_dmid(filenames = my_filenames)

write.csv(df, alignment_dmid_filename)
