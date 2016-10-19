library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"
#folder <- "/home/p230198/Peregrine"

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)

df <- collect_files_esses(fns)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_esses.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collected_esses.csv",
  row.names = TRUE
)
