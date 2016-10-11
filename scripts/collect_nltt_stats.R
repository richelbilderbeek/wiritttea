library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"
csv_filename_nltt_stat <- "../inst/extdata/collected_nltt_stats.csv"

# filenames
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)

df <- collect_files_nltt_stats(fns)

utils::write.csv(
  x = df,
  file = csv_filename_nltt_stat,
  row.names = TRUE
)

warnings()
