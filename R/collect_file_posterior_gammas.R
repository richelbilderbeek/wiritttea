#' Collect the gamma statistics of the BEAST2 posteriors
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @export
#' @examples
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_posterior_gammas(filename)
#'   testit::assert(names(df) ==
#'     c("sti", "ai", "pi", "si", "gamma_stat")
#'   )
#'   testit::assert(nrow(df) == 80)
#' @author Richel Bilderbeek
collect_file_posterior_gammas <- function(filename) {

  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }

  id <- NULL; rm(id) # nolint, should fix warning: collect_file_posterior_gammas: no visible binding for global variable ‘id’

  file <- wiritttes::read_file(filename)
  parameters <- file$parameters
  n_alignments <- as.numeric(parameters$n_alignments[2])
  n_beast_runs <- as.numeric(parameters$n_beast_runs[2])

  df <- NULL
  index <- 1

  for (sti in 1:2) {
    for (j in seq(1, n_alignments)) {
      for (k in seq(1, n_beast_runs)) {
        phylogenies <- wiritttes::get_posteriors(file)[[index]][[1]]$trees

        # 'id' column will be changed to 'si' in the end
        gamma_statistics <- wiritttea::collect_gamma_statistics(phylogenies)

        # Remove id column
        #gamma_statistics <- subset(
        #  gamma_statistics,
        #  select = -c(id) # nolint Putting 'gamma_statistics$' before ID will break the code
        #)
        testit::assert(!is.null(gamma_statistics$gamma))

        n_gamma_statistics <- nrow(gamma_statistics)
        this_df <- data.frame(
          sti = rep(sti, n_gamma_statistics),
          ai = rep(j, n_gamma_statistics),
          pi = rep(k, n_gamma_statistics)
        )
        this_df <- cbind(this_df, gamma_statistics)
        if (is.null(df)) {
          df <- this_df
        } else {
          df <- rbind(df, this_df)
        }
        index <- index + 1
      }
    }
  }

  df <- plyr::rename(df, c("id" = "si"))
  testit::assert(!is.null(df$gamma))
  df
}
