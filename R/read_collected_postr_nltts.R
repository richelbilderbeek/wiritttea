#' Read all the collected nLTT statistics of all posteriors
#' @return a dataframe
#' @examples
#'   df <- read_collected_posterior_nltts()
#'   testit::assert(names(df) ==
#'     c(
#'       "filename", "sti", "ai",
#'       "pi", "si", "nltt"
#'     )
#' @author Richel Bilderbeek
#' @export
read_collected_posterior_nltts <- function(
  filename = wiritttea::find_path("collect_files_posterior_nltts.csv")
) {
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
  df$si <- as.factor(df$si)
  df
}
