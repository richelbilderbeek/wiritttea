#' Performs the full analysis on all the .RDa files present in a
#' given folder. These .RDa files are in the format
#' created by the 'wirittttes' package
#' @param folder path of the folder containing the RDa files
#' @return nothing
#' @examples
#'   folder <- system.file("extdata", package = "wiritttea")
#'   do_analysis(folder)
#' @export
do_analysis <- function(folder = "~/GitHubs/wiritttea/inst/extdata") {

  wiritttea::collect_all(folder)
}
