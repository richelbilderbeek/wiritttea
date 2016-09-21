#' Collects the nLTT statistics of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @param dt the resolution of the nLTT plot,
#'   must be in range <0,1>, default is 0.001
#' @return A list with two dataframes of nLTTs
#' @export
collect_files_posterior_nltts <- function(filenames, dt) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Posteriors Normalized lineages through timeS
  pns <- NULL # Posterior Gamma statistics
  for (filename in filenames) {
    this_pns <- NULL
    tryCatch(
      this_pns <- wiritttea::collect_file_posterior_nltts(
        filename = filename, dt = dt
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_pns)) {
      this_pns <- data.frame(
        species_tree = NA,
        alignment = NA,
        beast_run = NA,
        state = NA,
        t = NA,
        nltt = NA
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
