#' Collects the gamma statistics of all phylogenies belonging to a
#' parameter file in the melted/uncast/long form
#'
#' @param filename name of the parameter file
#' @return A dataframe of gamma statistics of each phylogeny in time
#' @examples
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_gammas(filename)
#'   testit::assert(names(df) == c("species_tree_gammas", "posterior_gammas"))
#'   testit::assert(names(df$species_tree_gammas)
#'     == c("sti", "gamma_stat")
#'   )
#'   testit::assert(nrow(df$species_tree_gammas) == 2)
#'   testit::assert(nrow(df$posterior_gammas) == 80)
#' @export
collect_file_gammas <- function(filename) {

  if (length(filename) != 1) {
    stop("there must be exactly one filename supplied")
  }

  if (!wiritttes::is_valid_file(filename = filename)) {
    stop("invalid file")
  }

  species_tree_gammas <- wiritttea::collect_species_tree_gammas(filename)
  posterior_gammas <- wiritttea::collect_posterior_gammas(filename)

  return(
    list(
      species_tree_gammas = species_tree_gammas,
      posterior_gammas = posterior_gammas
    )
  )
}
