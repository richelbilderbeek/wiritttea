#' Collects the nLTT statistics of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @param dt the resolution of the nLTT plot,
#'   must be in range <0,1>, default is 0.001
#' @return A dataframe
#' @export
collect_files_stree_nltts <- function(filenames, dt = 0.001) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Species trees
  stns <- NULL # Species Trees Normalized lineaegs through timeS
  for (filename in filenames) {
    this_stns <- NULL
    tryCatch(
      this_stns <- collect_file_stree_nltts(
        filename = filename, dt = dt
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_stns)) {
      this_stns <- data.frame(
        sti = NA, t = NA, nltt = NA
      )
    }
    # Prepend a col with the filename
    this_filenames <- rep(basename(filename), times = nrow(this_stns))
    this_stns <- cbind(
      filename = this_filenames,
      this_stns
    )
    if (!is.null(stns)) {
      stns <- rbind(stns, this_stns)
    } else {
      stns <- this_stns
    }
  }

  return(stns)
}
