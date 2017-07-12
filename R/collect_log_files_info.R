#' Collects log file information in the melted/uncast/long form
#' @param filenames names of the parameter file
#' @return A dataframe with all information of all log files
#' @examples
#'   filenames <- c(
#'    find_path("toy_example_1.RDa"),
#'    find_path("toy_example_2.RDa")
#'  )
#'  df <- collect_files_n_taxa(filenames)
#'  testit::assert(names(df) == c("filename", "exit_status"))
#'  testit::assert(nrow(df) == length(filenames))
#' @export
collect_log_files_info <- function(filenames) {

  if (length(filenames) < 1) {
    stop("there must be at least one filename supplied")
  }

  # Log file info
  log_files_info <- NULL
  for (filename in filenames) {
    this_log_file_info <- NULL
    tryCatch(
      this_log_file_info <- collect_log_file_info(
        filename = filename
      ),
      error = function(msg) {} # nolint
    )
    if (is.null(this_log_file_info)) {
      this_log_file_info <- data.frame(
        exit_status = NA
      )
    }
    if (!is.null(n_taxa)) {
      log_files_info <- rbind(log_files_info, this_log_file_info)
    } else {
      log_files_info <- this_log_file_info
    }
  }
  df <- data.frame(
    filename = basename(filenames),
    exit_status = log_files_info$exit_status
  )
  testit::assert(nrow(df) == length(filenames))
  testit::assert(names(df) == c("filename", "exit_status"))
  return(df)
}
