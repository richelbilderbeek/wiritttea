library(wiritttea)
folder <- "/data/p230198"
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- wiritttea::collect_files_n_alignments(fns)

utils::write.csv(
  x = df,
  file = "collect_files_n_alignments.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_n_alignments.csv",
  row.names = TRUE
)

warnings()
