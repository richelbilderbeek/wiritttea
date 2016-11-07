library(wiritttea)
folder <- "/data/p230198"


dt <- 0.1

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)

df_species_tree_nltts <- collect_files_stree_nltts(fns, dt = dt)
df_posterior_nltts <- collect_files_posterior_nltts(fns, dt = dt)

utils::write.csv(
  x = df_species_tree_nltts,
  file = "collect_files_nltts_trees.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df_species_tree_nltts,
  file = "../inst/extdata/collect_files_nltts_trees.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df_posterior_nltts,
  file = "collect_files_nltts_posterior.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df_posterior_nltts,
  file = "../inst/extdata/collect_files_nltts_posterior.csv",
  row.names = TRUE
)

library(rmarkdown)

tryCatch(
  rmarkdown::render("../vignettes/analyse_nltts.Rmd", output_file =  "~/analyse_nltts.html"),
  error = function(msg) { message(msg) }
)

tryCatch(
  system("pandoc ~/analyse_nltts.html -o analyse_nltts.pdf"),
  error = function(msg) { message(msg) }
)

warnings()
