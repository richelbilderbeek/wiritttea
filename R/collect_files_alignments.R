#' Collects the quality of the alignments of the files
#' @param filenames names of the parameter files
#' @param show_progress shows the progress if set to TRUE
#' @return A dataframe with the columns 'filename', 'n_alignments_ok' (number
#'   of alignments that have a distance matrix with only non-zero and non-NA
#'   elements, except on the diagonal), 'n_alignments_zero' (number
#'   of alignments that have a distance matrix with zeroes next to the
#'   diagonal, indicating two identical DNA sequences in the alignment),
#'   and 'n_alignments_na' (number
#'   of alignments that have a distance matrix with NAs,
#'   indicating that two DNA sequences are two dissimilar to have
#'   their Jukes-Cantor distance measured)
#' @examples
#'   filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
#'   df <- collect_files_alignments(filenames)
#'   testit::assert(nrow(df) == 2)
#'   expected_names <- c(
#'     "filename",
#'     "n_alignments_ok",
#'     "n_alignments_zeroes",
#'     "n_alignments_na")
#'   testit::assert(all.equal(names(df), expected_names))
#' @export
collect_files_alignments <- function(filenames, show_progress = FALSE) {

  if (length(filenames) == 0) {
    stop("there must be at least one filename supplied")
  }

  df <- data.frame(
    filename = basename(filenames),
    n_alignments_ok = rep(0, length(filenames)),
    n_alignments_zeroes = rep(0, length(filenames)),
    n_alignments_na = rep(0, length(filenames))
  )

  for (i in seq_along(filenames)) {

    my_filename <- filenames[i]

    if (show_progress == TRUE) {
      print(my_filename)
    }
    testit::assert(file.exists(my_filename))

    tryCatch({
        file <- wiritttes::read_file(my_filename) # Can fail
        n_alignments <- wiritttes::extract_napst(file) * 2
        for (j in seq(1, n_alignments)) {
          alignment <- wiritttes::get_alignment_by_index(file, j)
          m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)
          # Detect if there is at least one NA
          if (!all(!is.na(m))) {
            df$n_alignments_na[i] <- df$n_alignments_na[i] + 1
          } else if (sum(m == 0.0) - nrow(m) > 0) {
            # Detect zeroes, except those on the diagonal
            df$n_alignments_zeroes[i] <- df$n_alignments_zeroes[i] + 1
          } else {
            df$n_alignments_ok[i] <- df$n_alignments_ok[i] + 1
          }
          gc() # Need to do so manually
        }
      },
      error = function(cond) {} #nolint
    )
  }
  df
}
