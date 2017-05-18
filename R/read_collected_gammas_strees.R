#' Read all the collected nLTT values of all species trees
#' @param filename name of the CSV file
#' @return a dataframe
#' @examples
#'   df <- read_collected_gammas_strees()
#'   testit::assert(names(df) == c("filename", "sti", "gamma_stat"))
#' @author Richel Bilderbeek
#' @export
read_collected_gammas_strees <- function(
  filename = wiritttea::find_path("collect_files_species_tree_gammas.csv")) {

  testit::assert(file.exists(filename))
  df <- utils::read.csv(
   file = filename,
   header = TRUE,
   stringsAsFactors = FALSE,
   row.names = 1
  )
  names(df)
  df$filename <- as.factor(df$filename)
  df$sti <- as.factor(df$sti)
  testit::assert(names(df) == c("filename", "sti", "gamma_stat"))
  df
}
