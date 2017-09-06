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
  wiritttea::read_collected_nltt_stats(filename)
}
