#' Reads the file with the collected alignments' qualities
#' @param csv_filename name of the CSV file
#' @return a data frame with all alignments' qualities
#' @author Richel Bilderbeek
#' @export
read_collected_alignments <- function(
  csv_filename = find_path("read_collected_alignments.csv")
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
