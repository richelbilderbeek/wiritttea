# Collects the parameters used in all .RDa files in one file
library(wiritttea)

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Supply a source folder")
}

folder <- args[1]

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- wiritttea::collect_files_parameters(fns)

utils::write.csv(
  x = df,
  file = "~/collect_files_parameters.csv",
  row.names = TRUE
)
