#' Read all the collected tree likelihoods of all posteriors
#' @param filename name of the file with all the collected posteriors' likelihoods
#' @return a dataframe
#' @usage
#' wiritttea::read_collected_posterior_likelihoods(
#'   filename = wiritttea::find_path("collect_files_posterior_likelihoods.csv")
#' )
#' @examples
#'   df <- read_collected_posterior_likelihoods()
#'   testit::assert(names(df) ==
#'     c(
#'       "filename", "sti", "ai",
#'       "pi", "si", "likelihood"
#'     )
#' @author Richel Bilderbeek
#' @export
read_collected_posterior_likelihoods <- function(
  filename = wiritttea::find_path("collect_files_posterior_likelihoods.csv")
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
