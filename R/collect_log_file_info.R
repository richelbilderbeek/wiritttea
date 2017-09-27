#' Collects information of a log file in the melted/uncast/long form
#' @param filename name of the .log file
#' @return A dataframe of log file info.
#'   The `exit_status` column contains
#'   exit statuses with the following values possible:
#'   `OK` means that no problems were encounters,
#'   `memory` denotes that there was more memory used than reserved,
#'   `died` means that the task died by a signal,
#'   `invalid_file` is stated when the .RDa file to read from was invalid,
#'   `alignment` and `no_dnabin` are caused from an unreadable or
#'     unmanagable alignment,
#'   `fasta` and `fasta_io` results from an unreadable FASTA file
#'   (a temporary created by `add_posterior`),
#'   `trees` results from an unreadable `.trees` file,
#'   `save_posterior` is caused by a failure when saving a BEAST2 posterior
#' @examples
#'   filename <- wiritttea::find_path("add_alignments_ok.log")
#'   df <- wiritttea::collect_log_file_info(filename)
#'   testit::assert(names(df) == c("filename", "exit_status", "sys_time"))
#'   testit::assert(nrow(df) == 1)
#' @export
collect_log_file_info <- function(filename) {

  if (length(filename) != 1) {
    stop("there must be exactly one filename supplied")
  }

  df <- data.frame(
    filename = basename(filename),
    exit_status = "OK",
    sys_time = 0.0,
    stringsAsFactors = FALSE
  )

  text <- wiritttea::file_to_lines(filename)
  if (length(grep(pattern = "slurmstepd: error: Exceeded step memory limit at some point", x = text)) > 0) { # nolint
    df$exit_status <- "memory"
  } else if (length(grep(pattern = "slurmstepd: error: get_exit_code task 0 died by signal", x = text)) > 0) { # nolint
    df$exit_status <- "died"
  } else if (length(grep(pattern = "\\.Call\\(\"rawStreamToDNAbin\", x\\)", x = text)) > 0) { # nolint
    df$exit_status <- "fasta"
  } else if (length(grep(pattern = "Error in value\\[\\[3L\\]\\]\\(cond\\) : invalid file", x = text)) > 0) { # nolint
    df$exit_status <- "invalid_file"
  } else if (length(grep(pattern = "Error: file.exists\\(beast_trees_filename\\) is not TRUE", x = text)) > 0) { # nolint
    df$exit_status <- "trees"
  } else if (length(grep(pattern = "In ape::read.FASTA\\(fasta_filename\\) :rm: write error: Input/output error", x = text)) > 0) { # nolint
    df$exit_status <- "fasta_io"
  } else if (length(grep(pattern = "Error in data.frame\\(sequences, row.names = labels\\)", x = text)) > 0) { # nolint
    df$exit_status <- "alignment"
  } else if (length(grep(pattern = "embedded nul\\(s\\) found in input", x = text)) > 0) { # nolint
    df$exit_status <- "save_posterior"
  } else if (length(grep(pattern = "Error: class\\(sequences_dnabin\\) == \"DNAbin\" is not TRUE", x = text)) > 0) { # nolint
    df$exit_status <- "no_dnabin"
  }


  # "Used CPU time       :    01:36:11 ("
  if (length(grep(pattern = "Used CPU time", x = text)) > 0) {
    line <- text[ grep(pattern = "Used CPU time", x = text) ]
    t <- stringr::str_extract(line,
      "[:digit:][:digit:]:[:digit:][:digit:]:[:digit:][:digit:]")
    # Only use the first hit
    if (length(t) > 1) t <- t[1]
    if (is.na(t)) {
      # "Used CPU time       :    ---"
      df$sys_time <- 0.0
    } else {
      # "Used CPU time       :    01:36:11 ("
      n_secs <- lubridate::period_to_seconds(lubridate::hms(t))
      df$sys_time <- n_secs
    }
  }

  testit::assert(names(df)
    == c("filename", "exit_status", "sys_time")
  )
  df
}
