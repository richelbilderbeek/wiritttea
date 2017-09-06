#' Collects the nLTT statistics of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A dataframe of nLTTs
#' @examples
#'   filenames <- wiritttea::find_paths(
#'      c("toy_example_1.RDa", "toy_example_2.RDa",
#'      "toy_example_3.RDa", "toy_example_4.RDa")
#'    )
#'    df <- wiritttea::collect_files_posterior_nltts(filenames)
#'    testit::assert(
#'      dplyr::all_equal(
#'        names(df),
#'        c("filename", "sti", "ai", "pi", "si", "nltt")
#'      )
#'    )
#'    testthat::expect_true(nrow(df) == 200)
#' @export
collect_files_posterior_nltts <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  df <- NULL
  for (filename in filenames) {
    this_df <- NULL
    tryCatch(
      this_df <- wiritttea::collect_file_posterior_nltts(
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
        nltt = NA
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
