#' Calculates the nLTT statistics from multiple clean files
#' @param filenames the names of the files
#' @return a distribution of nLTT statistics
#' @export
#' @examples
#'   nltt_stats <- wiritttea::collect_files_nltt_stats(
#'     filenames = c(
#'       find_path("toy_example_1.RDa"),
#'       find_path("toy_example_2.RDa")
#'     )
#'   )
#'   expected_names <- c("filename", "sti", "ai", "pi", "si", "nltt_stat")
#'   testit::assert(all(names(nltt_stats) == expected_names))
#' @author Richel Bilderbeek
collect_files_nltt_stats <- function(filenames) {

  # Check all files
  for (filename in filenames) {
    if (!wiritttes::is_valid_file(filename)) {
      stop("invalid file '",
        filename, "'"
      )
    }
  }

  # Calculate the number of rows needed
  n_rows <- 0
  for (filename in filenames) {
    tryCatch({
      file <- wiritttes::read_file(filename)
      nst <- 2 # Number of species trees
      napst <- wiritttes::extract_napst(file) # number of alignments per species tree # nolint
      nppa <- wiritttes::extract_nppa(file) # number of number of posteriors per alignment # nolint
      nspp <- wiritttes::extract_nspp(file) # number of states per posterior
      n_rows_for_this_file <- nst * napst * nppa * nspp
      n_rows <- n_rows + n_rows_for_this_file
    }, error = function(cond) {
      n_rows <- n_rows + 1
      }
    )
  }
  df <- data.frame(
    filename = rep(NA, n_rows),
    sti = rep(NA, n_rows),
    ai = rep(NA, n_rows),
    pi = rep(NA, n_rows),
    si = rep(NA, n_rows),
    nltt_stat = rep(NA, n_rows)
  )

  # Merging, a bit like this example code:
  # sub1 <- data.frame(y = c(1, 2), z = c(3, 4))                                     # nolint
  # sub2 <- data.frame(y = c(5, 6), z = c(7, 8))                                     # nolint
  # super <- data.frame(x = rep(c(1, 2), each = 2), y = rep(NA, 4), z = rep(NA, 4)) # nolint
  # super[1:2, c("y", "z")] <- sub1                                                # nolint
  # super[3:4, c("y", "z")] <- sub2                                                # nolint
  index <- 1
  for (filename in filenames) {
    if (wiritttes::is_valid_file(filename)) {
      nltt_stats <- wiritttea::collect_file_nltt_stats(
        filename = filename
      )
      df[
        index:(index + nrow(nltt_stats) - 1),
        c("sti", "ai", "pi", "si", "nltt_stat")
      ] <- nltt_stats
      df$filename[index:(index + nrow(nltt_stats) - 1)] <- rep(
        basename(filename), nrow(nltt_stats)
      )
      index <- index + nrow(nltt_stats)
    } else {
      df[
        index:(index + 1),
        sti = NA, ai = NA, pi = NA, si = NA, nltt_stat = NA
      ]
      index <- index + 1
    }
  }
  testit::assert(
    c("filename", "sti", "ai", "pi", "si", "nltt_stat")
      == names(df)
  )

  # Make factors
  df$filename <- as.factor(df$filename)
  df$sti <- as.factor(df$sti)
  df$ai <- as.factor(df$ai)
  df$pi <- as.factor(df$pi)
  df$si <- as.factor(df$si)

  df

}


#' Calculates the nLTT statistics from multiple files that may be invalid
#' @param filenames the names of the files
#' @return a distribution of nLTT statistics
#' @export
#' @examples
#'   nltt_stats <- collect_files_nltt_stats_dirty(
#'     filenames = c(
#'       find_path("toy_example_1.RDa"),
#'       "inva.lid",
#'       find_path("toy_example_2.RDa")
#'     )
#'   )
#'   expected_names <- c("filename", "sti", "ai", "pi", "si", "nltt_stat")
#'   testit::assert(all(names(nltt_stats) == expected_names))
#' @author Richel Bilderbeek
collect_files_nltt_stats_dirty <- function(filenames) {
  clean_filenames <- filenames[wiritttes::are_valid_files(filenames)]
  dirty_filenames <- filenames[!wiritttes::are_valid_files(filenames)]
  df_clean <- wiritttea::collect_files_nltt_stats(clean_filenames)
  n_dirty <- length(dirty_filenames)
  if (n_dirty > 0) {
    df_dirty <- data.frame(
      filename = dirty_filenames,
      sti = rep(NA, n_dirty),
      ai = rep(NA, n_dirty),
      pi = rep(NA, n_dirty),
      si = rep(NA, n_dirty),
      nltt_stat = rep(NA, n_dirty)
    )
    df <- rbind(df_clean, df_dirty)
    df
  } else {
    df_clean
  }
}