#' Read all the collected nLTT statistics of all posteriors
#' @param filename name of the file with all the collected posteriors' nLLTs
#' @param burn_in_fraction the fraction of earliest values that is discarded
#' @return a dataframe
#' @usage
#'   read_collected_posterior_nltts(
#      filename = wiritttea::find_path("collect_files_posterior_nltts.csv"),
#'     burn_in_fraction
#'   )
#' @examples
#'   df <- wiritttea::read_collected_posterior_nltts(
#'     filename = wiritttea::find_path("collect_files_posterior_nltts.csv"),
#'     burn_in_fraction = 0.2
#'   )
#'   testit::assert(names(df) ==
#'     c(
#'       "filename", "sti", "ai",
#'       "pi", "si", "nltt"
#'     )
#'   )
#' @author Richel Bilderbeek
#' @export
read_collected_posterior_nltts <- function(
  filename = wiritttea::find_path("collect_files_posterior_nltts.csv"),
  burn_in_fraction
) {
  wiritttea::read_collected_nltt_stats(
    filename = filename,
    burn_in_fraction = burn_in_fraction
  )
}
