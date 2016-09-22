#' Read all the collected gamma statistics of all posteriors
#' @return a dataframe
#' @examples
#'   df <- read_collected_gammas_postrs()
#'   testit::assert(names(df) ==
#'     c(
#'       "filename", "sti", "ai",
#'       "pi", "si", "gamma_stat"
#'     )
#'   )
#' @author Richel Bilderbeek
#' @export
read_collected_gammas_postrs <- function() {

  filename <- wiritttea::find_path("collect_files_posterior_gammas.csv")
  testit::assert(file.exists(filename))
  df <- utils::read.csv(
   file = filename,
   header = TRUE,
   stringsAsFactors = FALSE,
   row.names = 1
  )
  df$filename <- as.factor(df$filename)
  df$sti <- as.factor(df$sti)
  df$ai <- as.factor(df$ai)
  df$pi <- as.factor(df$pi)
  df$si <- as.factor(df$si)
  df
}
