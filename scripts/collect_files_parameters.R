library(wiritttea)
folder <- "/home/p230198/GitHubs/wiritttea/scripts"
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- wiritttea::collect_files_parameters(fns)
utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_parameters.csv",
  row.names = TRUE
)

tryCatch(
  rmarkdown::render("../vignettes/analyse_files.Rmd", output_file = "~/analyse_files.html"),
  error = function(msg) { message(msg) }
)

tryCatch(
  system("pandoc ~/analyse_files.html -o analyse_files.pdf"),
  error = function(msg) { message(msg) }
)

warnings()
