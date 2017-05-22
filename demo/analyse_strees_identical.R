# Analyse if the two sampled species trees are identical
library(wiritttea)
options(warn = 2) # Be strict
path_data <- "~/Peregrine20170509"
strees_filename <- "~/strees.csv"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) path_data <- args[1]
if (length(args) > 1) strees_filename <- args[2]

print(paste("path_data:", path_data))
print(paste("strees_filename:", strees_filename))



print("Create strees data file if absent")
if (!file.exists(strees_filename)) {
  print("File is absent, recreating")

  print("Collecting .RDa files")
  my_filenames <- list.files(path_data, pattern = "*.RDa", full.names = TRUE)

  print("Collecting strees_identical")
  df_strees <- wiritttea::collect_files_strees_identical(filenames = my_filenames)

  print("Saving strees_identical")
  write.csv(df_strees, strees_filename)
}

print("Load strees data")
df_strees <- wiritttea::read_collected_strees_identical(strees_filename)

print("Measure the success rate")
tryCatch( {
  df_strees_na <- df_strees[is.na(df_strees$strees), ]
  n_fail <- sum(df_strees_na)
  n_success <- nrow(df_strees) - n_fail
  df_success <- data.frame(
    name = c("success", "fail"), n = c(n_success, n_fail)
  )
  print(df_success)
  }, error = function(cond) {
    print("All simulations have NA for number of taxa")
  }
)
if (1 == 2) {

print("Plot  the success rate")
ggplot2::ggplot(
  df_success,
  ggplot2::aes(
    x = factor(""),
    y = df_success$n,
    fill = df_success$name
  )
) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::scale_x_discrete("") +
  ggplot2::scale_y_continuous("number of parameter sets") +
  ggplot2::coord_polar(theta = "y") +
  ggplot2::ggtitle("Incipient species trees created")

}
