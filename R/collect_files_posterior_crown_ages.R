#' Collects the tree crown_ages of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A data frame with filename, sti, ai, pi, si, crown_age
#' @examples
#'   filenames <- wiritttea::find_paths(
#'    c("toy_example_1.RDa", "toy_example_2.RDa",
#'    "toy_example_3.RDa", "toy_example_4.RDa")
#'  )
#'  df <- wiritttea::collect_files_posterior_crown_ages(filenames)
#'  testthat::expect_equal(
#'    names(df),
#'    c("filename", "sti", "ai", "pi", "si", "crown_age")
#'  )
#'  testthat::expect_true(nrow(df) == 220)
#' @export
collect_files_posterior_crown_ages <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  df <- NULL # Posterior Gamma statistics
  for (filename in filenames) {
    this_df <- NULL
    tryCatch(
      this_df <- wiritttea::collect_file_posterior_crown_ages(
        filename = filename
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_df)) {
      this_df <- data.frame(
        sti = NA,
        ai = NA,
        pi = NA,
        si = NA,
        crown_age = NA
      )
    }
    # Prepend a col with the filename
    this_filenames <- rep(basename(filename), times = nrow(this_df))
    this_df <- cbind(
      filename = this_filenames,
      this_df
    )
    if (!is.null(df)) {
      df <- rbind(df, this_df)
    } else {
      df <- this_df
    }
  }

  df
}
