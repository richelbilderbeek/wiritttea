#' Reads the file with the collected parameters
#' @param csv_filename name of the CSV file
#' @return a data frame with all parameters
#' @usage read_collected_parameters(
#'   csv_filename = wiritttea::find_path("collect_files_parameters.csv"))
#' @examples
#'   csv_filename <- wiritttea::find_path("collect_files_parameters.csv")
#'   df <- wiritttea::read_collected_parameters(csv_filename)
#'   testit::assert(nrow(df) == 4)
#'   testit::assert("rng_seed" %in% names(df))
#'   testit::assert("sirg" %in% names(df))
#'   testit::assert("siri" %in% names(df))
#'   testit::assert("scr" %in% names(df))
#'   testit::assert("erg" %in% names(df))
#'   testit::assert("eri" %in% names(df))
#'   testit::assert("age" %in% names(df))
#'   testit::assert("mutation_rate" %in% names(df))
#'   testit::assert("n_alignments" %in% names(df))
#'   testit::assert("sequence_length" %in% names(df))
#'   testit::assert("nspp" %in% names(df))
#'   testit::assert("n_beast_runs" %in% names(df))
#' @author Richel Bilderbeek
#' @export
read_collected_parameters <- function(
  csv_filename = wiritttea::find_path("collect_files_parameters.csv")
) {
  if (!file.exists(csv_filename)) {
    stop("Parameters file absent")
  }
  df <- utils::read.csv(
    file = csv_filename,
    header = TRUE,
    stringsAsFactors = FALSE,
    row.names = 1
  )
  if ("mcmc_chainlength" %in%  names(df)) {
    df$mcmc_chainlength <- df$mcmc_chainlength / 1000
    df <- plyr::rename(df, c("mcmc_chainlength" = "nspp"))
  }
  df
}
