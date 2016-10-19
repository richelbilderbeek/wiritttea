library(wiritttea)

folder <- "/home/p230198/GitHubs/wiritttea/scripts"

fns <- paste(
  folder, list.files(folder, pattern = "\\.RDa"), sep = "/"
)
df <- collect_files_gammas(fns)

utils::write.csv(
  x = df$species_tree_gamma_stats,
  file = "collect_files_gammas_species_trees.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df$species_tree_gamma_stats,
  file = "../inst/extdata/collect_files_gammas_species_trees.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df$posterior_gamma_stats,
  file = "collect_files_gammas_posterior.csv",
  row.names = TRUE
)

utils::write.csv(
  x = df$posterior_gamma_stats,
  file = "../inst/extdata/collect_files_gammas_posterior.csv",
  row.names = TRUE
)

library(rmarkdown)

tryCatch(
  rmarkdown::render("../vignettes/analyse_gammas.Rmd", output_file =  "~/analyse_gammas.html"),
  error = function(msg) { message(msg) }
)

tryCatch(
  system("pandoc ~/analyse_gammas.html -o analyse_gammas.pdf"),
  error = function(msg) { message(msg) }
)

warnings()
