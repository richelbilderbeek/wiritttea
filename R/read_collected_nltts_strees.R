#' Read all the collected nLTT values of all species trees
#' @return a dataframe
#' @examples
#'   df <- read_collected_nltts_strees()
#'   testit::assert(names(df) == c("filename", "sti", "t", "nltt"))
#' @author Richel Bilderbeek
#' @export
read_collected_nltts_strees <- function() {
  filename <- wiritttea::find_path("collect_files_species_tree_nltts.csv")
  testit::assert(file.exists(filename))
  df <- utils::read.csv(
   file = filename,
   header = TRUE,
   stringsAsFactors = FALSE,
   row.names = 1
  )
  df$species_tree <- as.factor(df$species_tree)
  testit::assert(names(df) == c("filename", "sti", "t", "nltt"))
  df
}
