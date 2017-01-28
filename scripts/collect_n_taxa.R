library(wiritttea)
#folder <- "/data/p230198"
folder <- "~/Peregrine"
fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- wiritttea::collect_files_n_taxa(fns)

utils::write.csv(
  x = df,
  file = "collect_files_n_taxa.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_n_taxa.csv",
  row.names = TRUE
)

library(rmarkdown)

tryCatch(
  rmarkdown::render("../vignettes/analyse_n_taxa.Rmd", output_file =  "~/analyse_n_taxa.html"),
  error = function(msg) { message(msg) }
)

tryCatch(
  system("pandoc ~/analyse_n_taxa.html -o analyse_n_taxa.pdf"),
  error = function(msg) { message(msg) }
)

warnings()

