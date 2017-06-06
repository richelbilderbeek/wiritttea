#' Reads the file with the collected species trees being identical
#' @param csv_filename name of the CSV file
#' @return a data frame with all parameters
#' @usage read_collected_strees_identical(
#'   csv_filename = wiritttea::find_path("collect_files_strees_identical.csv"))
#' @examples
#'   csv_filename <- wiritttea::find_path("collect_files_strees_identical.csv")
#'   strees_identical <- read_collected_strees_identical(csv_filename)
#'   testit::assert(names(strees_identical) == c(
#'     "filename", "strees_identical"
#'     )
#'   )
#'   testit::assert(is.factor(strees_identical$filename))
#'   testit::assert(is.factor(strees_identical$strees_identical))
#' @author Richel Bilderbeek
#' @export
read_collected_strees_identical <- function( # nolint keep function at this length
  csv_filename = wiritttea::find_path("collect_files_strees_identical.csv")
) {
  testit::assert(file.exists(csv_filename))
  df <- utils::read.csv(
    file = csv_filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  df$filename <- as.factor(df$filename)
  df$strees_identical <- as.factor(df$strees_identical)
  testit::assert(names(df) == c(
    "filename", "strees_identical"
    )
  )
  testit::assert(is.factor(df$filename))
  testit::assert(is.factor(df$strees_identical))
  df
}
