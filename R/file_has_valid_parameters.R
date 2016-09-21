#' Checks if a file is a valid parameter file
#' @param file a file that has been openened by read_file
#' @return TRUE or FALSE
#' @examples
#'   testit::assert(
#'     file_has_valid_parameters(
#'       file = read_file(find_path("toy_example_1.RDa"))
#'     )
#'   )
#' @author Richel Bilderbeek
#' @export
file_has_valid_parameters <- function(file) {

  parameters <- file$parameters
  if (extract_erg(file) < 0.0) {
    return(FALSE)
  }
  if (wiritttea::extract_eri(file) < 0.0) {
    return(FALSE)
  }
  if (wiritttea::extract_scr(file) < 0.0) {
    return(FALSE)
  }
  if (wiritttea::extract_sirg(file) < 0.0) {
    return(FALSE)
  }
  if (wiritttea::extract_siri(file) < 0.0) {
    return(FALSE)
  }
  if (!is.null(parameters$add_ougroup)) {
    return(FALSE)
  }

  if (as.numeric(parameters$age[2]) <= 0.0) {
    return(FALSE)
  }
  if (as.numeric(parameters$mutation_rate[2]) <= 0.0) {
    return(FALSE)
  }
  if (as.numeric(parameters$n_alignments[2]) < 1) {
    return(FALSE)
  }
  if (as.numeric(parameters$sequence_length[2]) < 1) {
    return(FALSE)
  }
  if (as.numeric(parameters$n_beast_runs[2]) < 1) {
    return(FALSE)
  }
  if (wiritttea::extract_nspp(file) < 1) {
    return(FALSE)
  }
  return(TRUE)
}
