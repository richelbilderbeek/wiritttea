#' Collect the alignments' DMIDs
#' @param filenames names of the RDa files
#' @return a data frame
#' @examples
#'  filenames <- c(
#'    find_path("toy_example_1.RDa"),
#'    find_path("toy_example_3.RDa")
#'  )
#'  df <- collect_files_alignments_dmid(filenames)
#'  testit::assert(all(names(df) == c("filename", "ai", "dmid")))
#'  testit::assert(nrow(df) == 2 * length(filenames))
#' @export
collect_files_alignments_dmid <- function(filenames) {
  # Assume all files have the same number of alignments
  n_alignments <- wiritttes::extract_napst(
    wiritttes::read_file(filenames[1])) * 2

  df <- data.frame(
    filename = rep(basename(filenames), each = n_alignments),
    ai = rep(seq(1, n_alignments), times = length(filenames)),
    dmid = rep(NA, length(filenames), each = n_alignments)
  )

  n_rows <- nrow(df)

  for (row in seq(1, n_rows)) {
    file_index <- 1 + trunc((row - 1)/ 4)
    my_filename <- filenames[file_index]
    testit::assert(file.exists(my_filename))

    tryCatch({
      file <- wiritttes::read_file(my_filename) # Can fail
      this_n_alignments <- wiritttes::extract_napst(file) * 2
      testit::assert(this_n_alignments == n_alignments)
      ai <- 1 + ((row - 1 ) %% n_alignments)
      alignment <- wiritttes::get_alignment_by_index(file, ai)
      m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)
      dmid <- wiritttea::calc_dmid(m)
      df$dmid[row] <- dmid
    }, error = function(cond) {} #nolint
    )
    gc() # Need to do so manually
  }
  df
}