#' Reads the file with the collected parameters
#' @param csv_filename name of the CSV file
#' @return a data frame with all parameters
#' @author Richel Bilderbeek
#' @export
read_collected_parameters <- function(
  csv_filename = wiritttea::find_path("collect_files_parameters.csv")
) {
  testit::assert(file.exists(csv_filename))
  df <- utils::read.csv(
    file = csv_filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  if ("mcmc_chainlength" %in%  names(df)) {
    df$mcmc_chainlength <- df$mcmc_chainlength / 1000
    df <- plyr::rename(df, c("mcmc_chainlength" = "nspp"))
  }
  df
}
