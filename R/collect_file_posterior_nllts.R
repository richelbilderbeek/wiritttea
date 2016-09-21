#' Collect the nLTT values of the BEAST2 posteriors
#' @param filename name of the file containing the parameters and results
#' @param dt the resolution of the nLTT plot,
#'   must be in range <0,1>, default is 0.001
#' @return a data frame
#' @author Richel Bilderbeek
#' @export
collect_file_posterior_nltts <- function(filename, dt) {
  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }

  file <- wiritttea::read_file(filename)
  parameters <- file$parameters
  n_alignments <- as.numeric(parameters$n_alignments[2])
  n_beast_runs <- as.numeric(parameters$n_beast_runs[2])

  df <- NULL
  index <- 1

  for (sti in 1:2) {
    for (j in seq(1, n_alignments)) {
      for (k in seq(1, n_beast_runs)) {
        phylogenies <- wiritttes::get_posteriors(file)[[index]][[1]]$trees
        nltt_values <- nLTT::get_nltt_values(phylogenies, dt = dt)

        n_nltt_values <- nrow(nltt_values)
        this_df <- data.frame(
          sti = rep(sti, n_nltt_values),
          ai = rep(j, n_nltt_values),
          pi = rep(k, n_nltt_values)
        )
        this_df <- cbind(this_df, nltt_values)
        if (is.null(df)) {
          df <- this_df
        } else {
          df <- rbind(df, this_df)
        }
        index <- index + 1
      }
    }
  }
  testit::assert(!is.null(df$nltt))
  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "id", "t", "nltt")
  )
  names(df) <- c("sti", "ai", "pi", "si", "t", "nltt")
  df
}
