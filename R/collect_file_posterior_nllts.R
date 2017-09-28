#' Collect the nLTT values of the BEAST2 posteriors
#' @param filename name of the file containing the parameters and results
#' @return a data frame with columns 'sti' (species tree index),
#'   'ai' (alignment index), 'pi' (posterior index), 'si' (posterior
#'   state index) and 'nltt' (normalized Lineages Through Time statistic).
#' @examples
#'   filename <- wiritttea::find_path("toy_example_3.RDa")
#'    df <- wiritttea::collect_file_posterior_nltts(filename)
#'    testthat::expect_equal(names(df),
#'      c("sti", "ai", "pi", "si", "nltt")
#'    )
#'    testthat::expect_true(nrow(df) == 80)
#' @author Richel Bilderbeek
#' @export
collect_file_posterior_nltts <- function(filename) {
  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }

  file <- wiritttes::read_file(filename)
  # napst: Number of Alignments Per Species Tree
  napst <- wiritttes::extract_napst(file)
  nppa <- wiritttes::extract_nppa(file) # Number of Posteriors Per Alignment
  nspp <- wiritttes::extract_nspp(file) # Number of States Per posterior

  df <- data.frame(
    sti = rep(seq(1, 2), each = napst * nppa * nspp),
    ai = rep(seq(1, napst), times = 2, each = nppa * nspp),
    pi = rep(seq(1, nppa), times = 2 * nppa, each = nspp),
    si = rep(seq(1, nspp), times = 2 * napst * nppa),
    nltt = rep(NA, times = 2 * napst * nppa * nspp)
  )

  index <- 1

  for (sti in 1:2) {
    species_tree <- wiritttes::get_species_tree_by_index(file, sti)
    for (ai in seq(1, napst)) {
      for (pi in seq(1, nppa)) {
        phylogenies <- wiritttes::get_posterior(
          file = file, sti = sti, ai = ai, pi = pi)$trees
        for (si in seq(1, nspp)) {
          tryCatch(
            df$nltt[index] <- nLTT::nLTTstat_exact(
              tree1 = species_tree,
              tree2 = phylogenies[[si]]
            ),
            error = function(cond) {} # nolint
          )
          index <- index + 1
        }
      }
    }
  }
  testit::assert(!is.null(df$nltt))
  testit::assert(names(df)
    ==  c("sti", "ai", "pi", "si", "nltt")
  )
  df
}
