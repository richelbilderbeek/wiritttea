library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"
#folder <- "/home/p230198/Peregrine"
csv_filename_esses <- "../inst/extdata/collected_esses.csv"

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)

df <- collect_files_esses(fns, verbose = FALSE)
write.csv(
  x = df,
  file = csv_filename_esses,
  row.names = TRUE
)
