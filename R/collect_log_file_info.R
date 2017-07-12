#' Collects information of a log file in the melted/uncast/long form
#'
#' @param filename name of the .log file
#' @return A dataframe of log file info
#' @examples
#'   filename <- wiritttea::find_path("add_alignments_ok.log")
#'   df <- wiritttea::collect_log_file_info(filename)
#'   testit::assert(names(df) == c("filename", "exit_status"))
#'   testit::assert(nrow(df) == 1)
#' @export
collect_log_file_info <- function(filename) {

  if (length(filename) != 1) {
    stop("there must be exactly one filename supplied")
  }

  df <- data.frame(
    filename = basename(filename),
    exit_status = "OK"
  )

  text <- wiritttea::file_to_lines(filename)
  if (length(grep(pattern = "slurmstepd: error: Exceeded step memory limit at some point", x = text)) > 0) {
    df$exit_status = "memory"
  }

  df$exit_status <- as.factor(df$exit_status)
  testit::assert(is.factor(df$exit_status))
  testit::assert(names(df)
    == c("filename", "exit_status")
  )
  df
}
