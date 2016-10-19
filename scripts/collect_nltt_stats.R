library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"

# filenames
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)

df <- collect_files_nltt_stats(fns)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_nltt_stats.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_nltt_stats.csv",
  row.names = TRUE
)

warnings()
