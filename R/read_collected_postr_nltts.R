#' Read all the collected nLTT statistics of all posteriors
#' @param filename name of the file with all the collected posteriors' nLLTs
#' @return a dataframe
#' @usage
#'  wiritttea::read_collected_posterior_nltts(
#'    filename = wiritttea::find_path("collect_files_posterior_nltts.csv")
#'  )
#' @examples
#'   df <- wiritttea::read_collected_posterior_nltts()
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
  wiritttea::read_collected_nltt_stats(filename)
}
