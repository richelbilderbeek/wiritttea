#' Collect the number of alignments in a parameter file
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @examples
#'  filename <- find_path("toy_example_3.RDa")
#'  df <- collect_file_n_alignments(filename)
#'  testit::assert(names(df) == c("n_alignments"))
#'  testit::assert(ncol(df) == 1)
#'  testit::assert(nrow(df) == 1)
#'  testit::assert(df$n_alignments[1] == 4)
#' @export
#' @author Richel Bilderbeek
collect_file_n_alignments <- function(filename) {

  if (!wiritttes::is_valid_file(filename = filename)) {
    stop("invalid file")
  }

  file <- wiritttes::read_file(filename)
  n <- sum(!is.na(file$alignments))
  return(data.frame(n_alignments = n))
}
