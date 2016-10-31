library(wiritttea)

folder <- "/data/p230198"

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- collect_files_nrbss(fns)

utils::write.csv(
  x = df,
  file = "collect_files_nrbss.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df,
  file = "../inst/extdata/collect_files_nrbss.csv",
  row.names = TRUE
)

library(rmarkdown)

tryCatch(
  rmarkdown::render("../vignettes/analyse_nrbss.Rmd", output_file =  "~/analyse_nrbss.html"),
  error = function(msg) { message(msg) }
)

tryCatch(
  system("pandoc ~/analyse_nrbss.html -o analyse_nrbss.pdf"),
  error = function(msg) { message(msg) }
)

warnings()
