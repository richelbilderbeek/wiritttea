#' Collects log file information in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A dataframe with all information of all log files
#' @examples
#'   filenames <- c(
#'    find_path("add_alignments_ok.log"),
#'    find_path("add_alignments_exceeded_memory.log")
#'  )
#'  df <- collect_log_files_info(filenames)
#'  testit::assert(names(df) == c("filename", "exit_status"))
#'  testit::assert(nrow(df) == length(filenames))
#'  testit::assert(df$exit_status[1] != df$exit_status[2])
#' @export
collect_log_files_info <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Log file info
  df <- data.frame(
    filename = basename(filenames),
    exit_status = rep(NA, length(filenames))
  )

  for (i in seq_along(filenames)) {
    filename <- filenames[i]
    tryCatch(
      df$exit_status[i] <- wiritttea::collect_log_file_info(
        filename = filename
      )$exit_status,
      error = function(msg) {} # nolint
    )
  }
  testit::assert(nrow(df) == length(filenames))
  testit::assert(names(df) == c("filename", "exit_status"))
  return(df)
}