#' Collects the tree likelihoods of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A data frame with filename, sti, ai, pi, si, likelihood
#' @examples
#'   filenames <- wiritttea::find_paths(
#'    c("toy_example_1.RDa", "toy_example_2.RDa",
#'    "toy_example_3.RDa", "toy_example_4.RDa")
#'  )
#'  df <- wiritttea::collect_files_pstr_likelihoods(filenames)
#'  testthat::expect_equal(
#'    names(df),
#'    c("filename", "sti", "ai", "pi", "si", "likelihood")
#'  )
#'  testthat::expect_true(nrow(df) == 220)
#' @export
collect_files_pstr_likelihoods <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Posteriors Normalized lineages through timeS
  pns <- NULL # Posterior Gamma statistics
  for (filename in filenames) {
    this_pns <- NULL
    tryCatch(
      this_pns <- wiritttea::collect_file_pstr_likelihoods(
        filename = filename
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_pns)) {
      this_pns <- data.frame(
        sti = NA,
        ai = NA,
        pi = NA,
        si = NA,
        likelihood = NA
      )
    }
    # Prepend a col with the filename
    this_filenames <- rep(basename(filename), times = nrow(this_pns))
    this_pns <- cbind(
      filename = this_filenames,
      this_pns
    )
    if (!is.null(pns)) {
      pns <- rbind(pns, this_pns)
    } else {
      pns <- this_pns
    }
  }

  return(pns)
}
