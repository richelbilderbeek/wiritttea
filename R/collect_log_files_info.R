#' Collects log file information in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @param show_progress show progress if TRUE
#' @return A dataframe with all information of all log files
#' @examples
#'   filenames <- c(
#'    find_path("add_alignments_ok.log"),
#'    find_path("add_alignments_exceeded_memory.log")
#'  )
#'  df <- collect_log_files_info(filenames)
#'  testit::assert(names(df) == c("filename", "exit_status", "sys_time"))
#'  testit::assert(nrow(df) == length(filenames))
#'  testit::assert(df$exit_status[1] != df$exit_status[2])
#' @export
collect_log_files_info <- function(filenames, show_progress = FALSE) {

  if (length(filenames) < 1) {
    df <- data.frame(
      filename = NA,
      exit_status = NA,
      sys_time = NA
    )
    return(df[0, ])
  }

  # Log file info
  df <- data.frame(
    filename = basename(filenames),
    exit_status = rep(NA, length(filenames)),
    sys_time = rep(NA, length(filenames))
  )

  for (i in seq_along(filenames)) {
    filename <- filenames[i]

    if (show_progress == TRUE) {
      print(filename)
    }

    tryCatch({
      this_df <- wiritttea::collect_log_file_info(
        filename = filename
      )
      df$exit_status[i] <- this_df$exit_status
      df$sys_time[i] <- this_df$sys_time
      },
      error = function(msg) {} # nolint
    )
  }
  testit::assert(nrow(df) == length(filenames))
  testit::assert(names(df) == c("filename", "exit_status", "sys_time"))
  return(df)
}
