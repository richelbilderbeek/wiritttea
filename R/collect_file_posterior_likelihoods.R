#' Collect the tree likelihoods of the BEAST2 posteriors
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @author Richel Bilderbeek
#' @export
collect_file_posterior_likelihoods <- function(filename) {
  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }

  file <- wiritttes::read_file(filename)
  parameters <- file$parameters
  n_alignments <- as.numeric(parameters$n_alignments[2])
  n_beast_runs <- as.numeric(parameters$n_beast_runs[2])

  df <- NULL
  index <- 1

  for (sti in 1:2) {
    for (j in seq(1, n_alignments)) {
      for (k in seq(1, n_beast_runs)) {
        likelihoods <- wiritttes::get_posteriors(
          file)[[index]][[1]]$estimates$likelihood

        n_likelihoods <- length(likelihoods)

        this_df <- data.frame(
          sti = rep(sti, n_likelihoods),
          ai = rep(j, n_likelihoods),
          pi = rep(k, n_likelihoods),
          si = seq(1, n_likelihoods)
        )
        this_df <- cbind(this_df, likelihoods)
        if (is.null(df)) {
          df <- this_df
        } else {
          df <- rbind(df, this_df)
        }
        index <- index + 1
      }
    }
  }
  testit::assert(!is.null(df$likelihoods))
  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "si", "likelihoods")
  )

  names(df) <- c("sti", "ai", "pi", "si", "likelihood")

  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "si", "likelihood")
  )
  df
}
