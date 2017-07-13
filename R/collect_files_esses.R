#' Collects the ESSes of all phylogenies belonging to the
#' parameter files in the melted/uncast/long form
#'
#' @param filenames names of the parameter files
#' @return A dataframe of ESSes for all files their posterior
#' @examples
#'   filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
#'   df <- collect_files_esses(filenames)
#'   testit::assert(nrow(df) == 16)
#' @export
collect_files_esses <- function(filenames) {

  if (length(filenames) == 0) {
    print(paste("filenames: '", filenames, "'", sep = ""))
    stop(
      "there must be at least one filename supplied, "
    )
  }
  for (filename in filenames) {
    if (!wiritttes::is_valid_file(filename = filename)) {
      stop(
        "invalid file '", filename, "'"
      )
    }
  }
  n_filenames_before <- length(filenames)
  df <- wiritttea::collect_file_esses(filenames[1])
  filenames <- utils::tail(filenames, length(filenames) - 1)
  n_filenames_after <- length(filenames)
  testit::assert(n_filenames_after == n_filenames_before - 1)

  for (filename in filenames) {
    df <- rbind(df, wiritttea::collect_file_esses(filename))
  }

  testit::assert(names(df) == c(
    "filename",
    "sti",
    "ai",
    "pi",
    "posterior",
     "likelihood",
     "prior",
     "treeLikelihood",
     "TreeHeight",
     "BirthDeath",
     "birthRate2",
     "relativeDeathRate2"
    )
  )
  df
}
