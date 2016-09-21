#' Collect the number of posteriors in a parameter file
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @examples
#'  filename <- find_path("toy_example_3.RDa")
#'  df <- collect_n_posteriors(filename)
#'  testit::assert(names(df) == c("n_posteriors"))
#'  testit::assert(ncol(df) == 1)
#'  testit::assert(nrow(df) == 1)
#'  testit::assert(df$n_posteriors[1] == 8)
#' @export
#' @author Richel Bilderbeek
collect_n_posteriors <- function(filename) {

  if (!wiritttes::is_valid_file(filename = filename)) {
    stop("invalid file")
  }

  file <- wiritttea::read_file(filename)
  n <- sum(!is.na(file$posteriors))
  return (data.frame(n_posteriors = n))
}
