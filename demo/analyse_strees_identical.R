# Analyse if the two sampled species trees are identical
library(wiritttea)
options(warn = 2) # Be strict
date <- "20170710"
path_data <- paste0("~/wirittte_data/", date)
strees_filename <- paste0("~/strees_", date, ".csv")

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

print("Measure the number of TRUE, FALSE and NA")
tryCatch( {
  print(dplyr::tally(dplyr::group_by(df_strees, strees_identical)))
  }, error = function(cond) {
    print("All simulations have NA for number of taxa")
  }
)
