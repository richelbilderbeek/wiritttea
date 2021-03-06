#' Calculates the nLTT statistics from a file
#' @param filename the name of a file
#' @return a distribution of nLTT statistics
#' @export
#' @examples
#'   nltt_stats <- collect_file_nltt_stats(
#'     filename = find_path("toy_example_1.RDa")
#'   )
#'   expected_names <- c("sti", "ai", "pi", "si", "nltt_stat")
#'   testit::assert(names(nltt_stats) == expected_names)
#' @author Richel Bilderbeek
collect_file_nltt_stats <- function(filename) {
  file <- wiritttes::read_file(filename)

  nst <- 2 # Number of species trees
  napst <- wiritttes::extract_napst(file) # number of alignments per species tree # nolint
  nppa <- wiritttes::extract_nppa(file) # number of number of posteriors per alignment # nolint
  nspp <- wiritttes::extract_nspp(file) # number of states per posterior # nolint
  n_rows <- nst * napst * nppa * nspp


  stis <- rep(c(1, 2), each = napst * nppa * nspp)
  ais <- rep(1:napst, each = nppa * nspp, times = 2)
  pis <- rep(1:nppa, each = nspp, times = 2 * napst)
  sis <- rep(1:nspp, times = 2 * napst * nppa)

  testit::assert(n_rows == length(stis))
  testit::assert(n_rows == length(ais))
  testit::assert(n_rows == length(pis))
  testit::assert(n_rows == length(sis))

  df <- data.frame(
    sti = stis,
    ai = ais,
    pi = pis,
    si = sis,
    nltt_stat = rep(NA, n_rows)
  )

  index <- 1
  for (sti in 1:2) {
    focal_phylogeny <- wiritttes::get_species_tree_by_index(
      file = file, sti = sti
    )

    testit::assert(class(focal_phylogeny) == "phylo")
    for (ai in 1:napst) {
      for (pi in 1:nppa) {

        # Some files may lack a posterior
        posterior <- NA
        tryCatch(
          posterior <- wiritttes::get_posterior(
            file = file, sti = sti, ai = ai, pi = pi
          ), error = function(msg) {
            print(paste0("File ", filename, " lacks a posterior"))
          }
        )
        # If no posterior, then this will be the nLTT statistic
        nltt_stats <- data.frame(id = 1, nltt_stat = NA)

        # If there is a posterior, some calculations must be made
        if (length(posterior) > 1 || !is.na(posterior)) {
          posterior_trees <- posterior$trees
          # If possible, extract the nLTT statistics
          if (length(posterior_trees) > 1 ||
              (!is.null(posterior_trees) && !is.na(posterior_trees))
            ) {
            nltt_stats <- wiritttea::collect_nltt_stats(
              phylogeny = focal_phylogeny,
              others = posterior_trees
            )
            testit::assert(nspp == length(nltt_stats$nltt_stat))
            testit::assert(length(nltt_stats$nltt_stat) == nrow(nltt_stats))
          }
        }
        df$nltt_stat[
          index:(index + nrow(nltt_stats) - 1)
        ] <- nltt_stats$nltt_stat
        index <- index + nrow(nltt_stats)
      }
    }
  }

  testit::assert(names(df) == c("sti", "ai", "pi", "si", "nltt_stat"))
  df
}
