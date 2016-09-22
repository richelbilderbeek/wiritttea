#' Collects the NRBS values of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A dataframes of NRBS values
#' @examples
#'   filenames <- c(
#'     find_path("toy_example_3.RDa"),
#'     find_path("toy_example_4.RDa")
#'   )
#'   df <- collect_files_nrbss(filenames)
#'   expected <- c(
#'     "filename", "sti", "ai",
#'     "pi", "si", "nrbs"
#'   )
#'   testit::assert(names(df) == expected)
#'   testit::assert(nrow(df) == 160)
#' @export
collect_files_nrbss <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Species trees
  df <- NULL
  for (filename in filenames) {
    this_df <- NULL
    tryCatch(
      this_df <- collect_file_nrbss(filename),
      error = function(msg) {} # nolint
    )
    if (is.null(this_df)) {
      this_df <- data.frame(
        sti = NA,
        ai = NA,
        pi = NA,
        si = NA,
        nrbs = NA
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
