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
    exit_status = "OK",
    stringsAsFactors = FALSE
  )

  text <- wiritttea::file_to_lines(filename)
  if (length(grep(pattern = "slurmstepd: error: Exceeded step memory limit at some point", x = text)) > 0) {
    df$exit_status <- "memory"
  } else if (length(grep(pattern = "slurmstepd: error: get_exit_code task 0 died by signal", x = text)) > 0) {
    df$exit_status <- "died"
  } else if (length(grep(pattern = "\\.Call\\(\"rawStreamToDNAbin\", x\\)", x = text)) > 0) {
    df$exit_status <- "fasta"
  } else if (length(grep(pattern = "Error in value\\[\\[3L\\]\\]\\(cond\\) : invalid file", x = text)) > 0) {
    df$exit_status <- "invalid_file"
  } else if (length(grep(pattern = "Error: file.exists\\(beast_trees_filename\\) is not TRUE", x = text)) > 0) {
    df$exit_status <- "trees"
  } else if (length(grep(pattern = "In ape::read.FASTA\\(fasta_filename\\) :rm: write error: Input/output error", x = text)) > 0) {
    df$exit_status <- "fasta_io"
  } else if (length(grep(pattern = "Error in data.frame\\(sequences, row.names = labels\\)", x = text)) > 0) {
    df$exit_status <- "alignment"
  }

  testit::assert(names(df)
    == c("filename", "exit_status")
  )
  df
}
