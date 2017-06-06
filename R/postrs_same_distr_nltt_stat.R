#' Tests if the nLTT statistics between posteriors
#' are of the same distribution
#' @param df data frame with column names 'filename',
#'   'sti' (Species Tree Index), 'ai' (Alignment Index), 'pi' (Posterior
#'  Index), 'si' (State Index) and 'nltt_stat' (the nLTT statistic between
#'  that posterior state its phylogeny and the sampled species tree)
#' @return data frame
#' @examples
#'   nltt_stats <- read_collected_nltt_stats()
#'   df <- postrs_same_distr_nltt_stat(nltt_stats)
#'   testit::assert(all(names(df) == c("filename", "sti", "ai", "same_distr")))
#' @export
postrs_same_distr_nltt_stat <- function(df) {
  filename <- NULL; rm(filename)
  sti <- NULL; rm(sti)
  ai <- NULL; rm(ai)
  pi <- NULL; rm(pi)
  si <- NULL; rm(si)
  nltt_stat <- NULL; rm(nltt_stat)
  A <- NULL; rm(A) # nolint nLTT package does not use snake_case
  B <- NULL; rm(B) # nolint nLTT package does not use snake_case

  `%>%` <- dplyr::`%>%`

  if ("filename" %in% names(df) &&
    "sti" %in% names(df) &&
    "ai" %in% names(df) &&
    "pi" %in% names(df) &&
    "si" %in% names(df) &&
    "nltt_stat" %in% names(df)
  ) {
    # Spread the posterior indices over multiple columns
    df <- df %>% tidyr::spread(pi, nltt_stat)
    # Rename columns with numbers
    df <- plyr::rename(df, c("1" = "A", "2" = "B"))
    # Remove the si column
    df <- subset(df, select = -c(si))

    df <- df %>%
      dplyr::group_by(filename, sti, ai) %>%
      dplyr::summarise(
        same_distr = are_from_same_distribution(A, B)
      )
    return(df)
  }
  stop("Invalid data frame")
}
