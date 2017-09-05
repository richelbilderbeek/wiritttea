#' Collects the tree likelihoods of all phylogenies belonging to a
#' multiple parameter file in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A data frame with filename, sti, ai, pi, si, likelihood
#' @export
collect_files_posterior_likelihoods <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Posteriors Normalized lineages through timeS
  pns <- NULL # Posterior Gamma statistics
  for (filename in filenames) {
    this_pns <- NULL
    tryCatch(
      this_pns <- wiritttea::collect_file_posterior_likelihoods(
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
