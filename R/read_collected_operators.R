#' Reads the file with the collected BEAST2 operators' acceptances
#' @param csv_filename name of the CSV file
#' @return a data frame with all operators' acceptances
#' @author Richel Bilderbeek
#' @export
read_collected_operators <- function(
  csv_filename = wiritttea::find_path("read_collected_operators.csv")
) {
  testit::assert(file.exists(csv_filename))
  df <- utils::read.csv(
    file = csv_filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  df$filename <- as.factor(df$filename)
  df

}
