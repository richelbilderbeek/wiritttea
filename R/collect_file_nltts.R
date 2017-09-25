#' Collects the nLTTs of all phylogenies belonging to a
#' parameter file in the melted/uncast/long form
#'
#' @param filename name of the parameter file
#' @param dt the resolution of the nLTT plot,
#'   must be in range <0,1>, default is 0.001
#' @return A dataframe of gamma statistics of each phylogeny in time
#' @examples
#'   dt <- 0.1
#'   filename <- find_path("toy_example_3.RDa")
#'   df <- collect_file_nltts(filename)
#'   testit::assert(names(df) == c("species_tree_nltts", "posterior_nltts"))
#'   testit::assert(names(df$species_tree_nltts)
#'     == c("sti", "t", "nltt")
#'   )
#'   testit::assert(nrow(df$species_tree_nltts) > 2)
#'   testit::assert(nrow(df$posterior_nltts) > 80)
#' @export
collect_file_nltts <- function(filename, dt = 0.001) {

  if (length(filename) != 1) {
    stop(
      "there must be exactly one filename supplied"
    )
  }
  if (!wiritttes::is_valid_file(filename = filename)) {
    stop(
      "invalid file '", filename, "'"
    )
  }

  species_tree_nltts <- wiritttea::collect_file_stree_nltts(
    filename = filename, dt = dt
  )
  posterior_nltts <- wiritttea::collect_file_posterior_nltts(
    filename = filename
  )

  return(
    list(
      species_tree_nltts = species_tree_nltts,
      posterior_nltts = posterior_nltts
    )
  )
}
