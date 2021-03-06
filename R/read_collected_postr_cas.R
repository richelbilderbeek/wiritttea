#' Read all the collected tree crown_ages of all posteriors
#' @param filename name of the file with all the collected
#'   posteriors' crown ages
#' @return a dataframe
#' @usage
#' read_collected_pstr_crown_ages(
#'   filename = wiritttea::find_path("collect_files_posterior_crown_ages.csv")
#' )
#' @examples
#'   df <- wiritttea::read_collected_pstr_crown_ages()
#'   testit::assert(
#'     all(
#'       names(df) == c("filename", "sti", "ai", "pi", "si", "crown_age")
#'     )
#'   )
#' @author Richel Bilderbeek
#' @export
read_collected_pstr_crown_ages <- function(
   filename = wiritttea::find_path("collect_files_posterior_crown_ages.csv")
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
