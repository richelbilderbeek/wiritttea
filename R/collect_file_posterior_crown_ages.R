#' Collect the crown ages of the BEAST2 posteriors
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @note BEAST2 calls this parameter 'TreeHeight'
#' @examples
#'   filename <- wiritttea::find_path("toy_example_3.RDa")
#'   df <- wiritttea::collect_file_posterior_crown_ages(filename)
#'   testthat::expect_equal(
#'     names(df),
#'     c("sti", "ai", "pi", "si", "crown_age")
#'   )
#'   testthat::expect_true(nrow(df) == 88)
#' @author Richel Bilderbeek
#' @export
collect_file_posterior_crown_ages <- function(filename) {
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
        crown_ages <- wiritttes::get_posteriors(file)[[index]][[1]]$estimates$TreeHeight

        n_crown_ages <- length(crown_ages)

        this_df <- data.frame(
          sti = rep(sti, n_crown_ages),
          ai = rep(j, n_crown_ages),
          pi = rep(k, n_crown_ages),
          si = seq(1, n_crown_ages)
        )
        this_df <- cbind(this_df, crown_ages)
        if (is.null(df)) {
          df <- this_df
        } else {
          df <- rbind(df, this_df)
        }
        index <- index + 1
      }
    }
  }
  testit::assert(!is.null(df$crown_ages))
  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "si", "crown_ages")
  )

  names(df) <- c("sti", "ai", "pi", "si", "crown_age")

  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "si", "crown_age")
  )
  df
}
