#' Read all the collected nLTT values of all posteriors
#' @return a dataframe
#' @examples
#'   df <- wiritttea::read_collected_nltts_postrs()
#'   testit::assert(
#'     all(names(df) ==
#'       c(
#'         "filename", "sti", "ai",
#'         "pi", "si", "nltt"
#'       )
#'     )
#'   )
#' @author Richel Bilderbeek
#' @export
read_collected_nltts_postrs <- function() {

  filename <- wiritttea::find_path("collect_files_posterior_nltts.csv")
  testit::assert(file.exists(filename))
  df <- utils::read.csv(
   file = filename,
   header = TRUE,
   stringsAsFactors = FALSE,
   row.names = 1
  )
  df$sti <- as.factor(df$sti)
  df$ai <- as.factor(df$ai)
  df$pi <- as.factor(df$pi)
  df
}
