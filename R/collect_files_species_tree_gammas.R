#' Collects the gamma statistics of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A list with two dataframes of gamma statistics
#' @examples
#'  filenames <- c(
#'    find_path("toy_example_3.RDa"),
#'    find_path("toy_example_4.RDa")
#'  )
#'  df <- collect_files_stree_gammas(filenames)
#'  testit::assert(
#'    names(df) ==
#'    c("filename", "sti", "gamma_stat")
#'  )
#'  testit::assert(nrow(df) == 4)
#' @export
collect_files_stree_gammas <- function(filenames) {

  if (length(filenames) < 1) {
    stop(
      "collect_files_gammas: ",
      "there must be at least one filename supplied"
    )
  }

  # Species trees
  stgs <- NULL # Species Trees Gamma statistics
  for (filename in filenames) {
    this_stgs <- NULL
    tryCatch(
      this_stgs <- collect_file_stree_gammas(filename),
      error = function(msg) {} # nolint
    )
    if (is.null(this_stgs)) {
      this_stgs <- data.frame(sti = NA, gamma_stat = NA)
    }
    # Prepend a col with the filename
    this_filenames <- rep(basename(filename), times = nrow(this_stgs))
    this_stgs <- cbind(
      filename = this_filenames,
      this_stgs
    )
    if (!is.null(stgs)) {
      stgs <- rbind(stgs, this_stgs)
    } else {
      stgs <- this_stgs
    }
  }
  return(stgs)
}
