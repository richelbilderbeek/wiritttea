library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- wiritttea::collect_files_n_posteriors(fns)
write.csv(
  x = df,
  file = "../inst/extdata/collected_n_posteriors.csv",
  row.names = TRUE
)

warnings()
