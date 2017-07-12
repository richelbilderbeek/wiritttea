#' Reads the file with the collected log files info
#' @param csv_filename name of the CSV file
#' @return a data frame with all log files' information
#' @author Richel Bilderbeek
#' @export
read_collected_log_files_info <- function(
  csv_filename
) {
  testit::assert(file.exists(csv_filename))
  df <- utils::read.csv(
    file = csv_filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  df$exit_status <- as.factor(df$exit_status)
  df

}
