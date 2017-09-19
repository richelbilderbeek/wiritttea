# nstpist: Number of Species Trees Per Incipient Species Tree
# napst: Number of Alignments per Species Tree
# nppa: Number of Posteriors per Alignment
#' @examples
#'   rda_filename <- "test.RDa"
#'   log_filenames <- create_log_filenames(rda_filename, 2,2,2)
#'   testit::assert(log_filenames[1] == "test_1_1_1.log")
#'   testit::assert(log_filenames[2] == "test_1_1_2.log")
#'   testit::assert(log_filenames[3] == "test_1_2_1.log")
#'   testit::assert(log_filenames[4] == "test_1_2_2.log")
#'   testit::assert(log_filenames[5] == "test_2_1_1.log")
#'   testit::assert(log_filenames[6] == "test_2_1_2.log")
#'   testit::assert(log_filenames[7] == "test_2_2_1.log")
#'   testit::assert(log_filenames[8] == "test_2_2_2.log")
#' @export
create_log_filenames <- function(rda_filename, nstpist, napst, nppa)
{
  log_filenames <- NULL
  base <- tools::file_path_sans_ext(rda_filename)
  for (sti in seq(1, nstpist)) {
    for (ai in seq(1, napst)) {
      for (pi in seq(1, nppa)) {
        log_filenames <- c(log_filenames,
          paste0(base, "_", sti, "_", ai, "_", pi, ".log")
        )
      }
    }
  }
  log_filenames
}
