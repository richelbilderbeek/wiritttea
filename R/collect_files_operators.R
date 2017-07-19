#' Calculates the BEAST2 operators from multiple files
#' @param filenames the names of the .xml.state files
#' @return a data frame with the operators' acceptances
#' @export
#' @examples
#'   nltt_stats <- collect_files_operators(
#'     filenames = rep(find_path("collect_files_operators.xml.state"), 2)
#'   )
#' @author Richel Bilderbeek
collect_files_operators <- function(
  filenames = rep(find_path("collect_files_operators.xml.state"), 2)) {

  # Calculate the number of rows needed
  n_rows <- 0
  for (filename in filenames) {
    n_rows <- n_rows + nrow(RBeast::parse_beast_state_operators(filename))

  }
  df <- data.frame(
    operator = rep(NA, n_rows),
    p = rep(NA, n_rows),
    accept = rep(NA, n_rows),
    reject = rep(NA, n_rows),
    acceptFC = rep(NA, n_rows),
    rejectFC = rep(NA, n_rows),
    rejectIv = rep(NA, n_rows),
    rejectOp = rep(NA, n_rows),
    filename = rep(NA, n_rows)
  )


  index <- 1
  for (filename in filenames) {
    this_df <- RBeast::parse_beast_state_operators(filename)
    this_df$filename = basename(filename)
    df[
      index:(index + nrow(this_df) - 1),
    ] <- this_df
    index <- index + nrow(this_df)
  }

  # Put filename in the front
  df <- dplyr::select(df, filename, dplyr::everything())
  # Make factors
  df$filename <- as.factor(df$filename)

  expected_names <- c("filename", "operator", "p", "accept", "reject", "acceptFC",
    "rejectFC", "rejectIv", "rejectOp")
  testit::assert(names(df) == expected_names)

  df

}
