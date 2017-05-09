#' Collects the NRBS values between species trees and
#' posteriors in a parameter file in the melted/uncast/long form
#'
#' @param filename name of the parameter file
#' @return A dataframe of NRBS values between
#'   each species tree and their posteriors
#' @examples
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_nrbss(filename)
#'   testit::assert(names(df) == c("sti", "ai", "pi", "si", "nrbs"))
#'   testit::assert(nrow(df) == 80)
#' @export
collect_file_nrbss <- function(filename) {

  if (length(filename) != 1) {
    stop("there must be exactly one filename supplied")
  }
  if (!wiritttes::is_valid_file(filename = filename)) {
    stop("invalid file")
  }

  file <- wiritttes::read_file(filename)

  n_species_trees <- 2
  n_alignments <- as.numeric(
    file$parameters$n_alignments[2]
  )
  n_beast_runs <- as.numeric(
    file$parameters$n_beast_runs[2]
  )
  n_states <- wiritttes::extract_nspp(file)
  n_rows <- n_species_trees * n_alignments * n_beast_runs * n_states

  # Create an empty data frame like this:
  # S A B T N    <- S: species tree index
  # 1 1 1 1 NA      A: alignment index
  # 1 1 1 2 NA      B: BEAST2 run index
  # 1 1 2 1 NA      T: MCMC sTate index
  # 1 1 2 2 NA      N: NRBS value
  # 1 2 1 1 NA
  # 1 2 1 2 NA
  # 1 2 2 1 NA
  # 1 2 2 2 NA
  # 2 1 1 1 NA
  # 2 1 1 2 NA
  # 2 1 2 1 NA
  # 2 1 2 2 NA
  # 2 2 1 1 NA
  # 2 2 1 2 NA
  # 2 2 2 1 NA
  # 2 2 2 2 NA
  df <- data.frame(
    sti = rep(seq(1, n_species_trees), each = n_alignments * n_beast_runs * n_states), # nolint
    ai = rep(seq(1, n_alignments), each = n_states * n_beast_runs, times = n_species_trees), # nolint
    pi = rep(seq(1, n_beast_runs), each = n_states, times = n_species_trees * n_alignments), # nolint
    si = rep(seq(1, n_states), n_species_trees * n_beast_runs * n_alignments), # nolint
    nrbs = rep(NA, n_rows),
    stringsAsFactors = FALSE
  )

  for (i in 1:n_rows) {

    sti <- df$sti[i] # species tree index
    ai <- df$ai[i] # alignment index
    pi <- df$pi[i] # posterior index
    si <- df$si[i] # state index
    # st: species tree
    st <- wiritttes::get_species_tree_by_index(file = file, sti = sti)
    testit::assert(class(st) == "phylo")
    testit::assert(si >= 1)
    testit::assert(si <= length(wiritttes::get_posterior(file, sti = sti, ai = ai, pi = pi)$trees)) # nolint
    # pt: posterior state tree, of type phylo
    pt <- wiritttes::get_posterior(
      file, sti = sti, ai = ai, pi = pi
    )$trees[[si]]
    testit::assert(class(pt) == "phylo")
    testit::assert(length(st$tip.label) == length(pt$tip.label))
    testit::assert(all.equal(sort(st$tip.label), sort(pt$tip.label)))
    df$nrbs[i] <- NA
    tryCatch(
      df$nrbs[i] <- nrbs(st, pt),
      error = function(msg) {} # nolint
    )
  }

  df
}
