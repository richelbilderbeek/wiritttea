#' See if a file its two species trees have different branch lengths
#' @param file The file, as read from wiritttes::read_file
#' @return TRUE if the two species have different branch lengths, else FALSE
#'  # Create a parameter file
#'   filename <- "add_species_trees_example.RDa"
#'   save_parameters_to_file(
#'     rng_seed = 42,
#'     sirg = 0.5,
#'     siri = 0.5,
#'     scr = 0.5,
#'     erg = 0.5,
#'     eri = 0.5,
#'     age = 5,
#'     mutation_rate = 0.1,
#'     n_alignments = 1,
#'     sequence_length = 10,
#'     nspp = 10,
#'     n_beast_runs = 1,
#'     filename = filename
#'   )
#'
#'   # Simulate an incipient species tree
#'   add_pbd_output(filename)
#'
#'   # Add the species trees
#'   add_species_trees(filename = filename)
#'   testit::assert(has_species_trees(read_file(filename)))
#'
#'   testit::assert(have_same_strees(read_file(filename)))
#'
#' @author Richel Bilderbeek
#' @export
have_same_strees <- function(file) {
  if (!wiritttes::has_species_trees(file)) {
    stop("File lacks species trees. ",
      "These can be added by running wiritttes::add_species_trees")
  }
  brts_1 <- sort(ape::branching.times(wiritttes::get_species_tree_youngest(file)))
  brts_2 <- sort(ape::branching.times(wiritttes::get_species_tree_oldest(file)))
  return(all.equal(brts_1, brts_2))
}
