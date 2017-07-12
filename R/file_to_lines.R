#' Read a file and convert it to a vector of strings, in complexity O(2n)
#' @param filename the name of a file
#' @return the text of the filename as a vector
#' @examples
#'   text <- wiritttea::file_to_lines(filename = wiritttea::find_path("add_alignments_ok.log"))
#'   testit::assert(length(text) == 50)
#' @author Richel Bilderbeek
#' @export
file_to_lines <- function(filename) {

  if (!file.exists(filename)) {
    return(NA)
  }

  # Count the number of lines, to prevent growing text in O(n^2)
  n_lines <- 0
  con <- file(filename, "r")
  while (TRUE) {
    line <- readLines(con, n = 1)
    if (length(line) == 0) {
      break
    }
    n_lines <- n_lines + 1
  }
  close(con)

  # Read the text
  text <- rep(NA, n_lines)
  con <- file(filename, "r")
  for (i in seq(1, n_lines)) {
    text[i] <- readLines(con, n = 1)
  }
  close(con)
  text
}
