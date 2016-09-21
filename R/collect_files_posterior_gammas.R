#' Collects the gamma statistics of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A list with two dataframes of gamma statistics
#' @examples
#'  filenames <- c(
#'    find_path("toy_example_3.RDa"),
#'    find_path("toy_example_4.RDa")
#'  )
#'  df <- collect_files_posterior_gammas(filenames)
#'  testit::assert(
#'    names(df) ==
#'    c("filename", "sti", "gamma_stat")
#'  )
#'  testit::assert(nrow(df) == 160)
#' @export
collect_files_posterior_gammas <- function(filenames) {

  if (length(filenames) < 1) {
    stop(
      "collect_files_gammas: ",
      "there must be at least one filename supplied"
    )
  }

  # Posteriors trees
  pgs <- NULL # Posterior Gamma statistics
  for (filename in filenames) {
    this_pgs <- NULL
    tryCatch(
      this_pgs <- collect_file_posterior_gammas(filename),
      error = function(msg) {} # nolint
    )
    if (is.null(this_pgs)) {
      this_pgs <- data.frame(
        species_tree = NA,
        alignment = NA,
        beast_run = NA,
        gamma_stat = NA
      )
    }
    # Prepend a col with the filename
    this_filenames <- rep(basename(filename), times = nrow(this_pgs))
    this_pgs <- cbind(
      filename = this_filenames,
      this_pgs
    )
    if (!is.null(pgs)) {
      pgs <- rbind(pgs, this_pgs)
    } else {
      pgs <- this_pgs
    }
  }

  return(pgs)
}
