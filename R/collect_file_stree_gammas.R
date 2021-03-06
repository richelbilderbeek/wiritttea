#' Collect the gamma statistics of the species trees with outgroup
#' @param filename name of the file containing the parameters and results
#' @return a data frame
#' @examples
#'  filename <- find_path("toy_example_1.RDa")
#'  df <- collect_file_stree_gammas(filename)
#'  testit::assert(names(df) == c("sti", "gamma_stat"))
#'  testit::assert(nrow(df) == 2)
#'  testit::assert(!is.na(df$gamma_stat))
#' @export
#' @author Richel Bilderbeek
collect_file_stree_gammas <- function(filename) {

  if (!wiritttes::is_valid_file(filename)) {
    stop("invalid file")
  }
  file <- wiritttes::read_file(filename)

  df <- NULL

  for (sti in 1:2) {
    phylogeny <- NA
    g <- NA
    tryCatch(
      phylogeny <- wiritttes::get_species_tree_by_index(file = file, sti = sti),
      error = function(msg) {} # nolint
    )


    if (class(phylogeny) == "phylo") {
      g <- ape::gammaStat(phylogeny)
    }

    # Remove id column
    this_df <- data.frame(
      sti = sti,
      gamma_stat = g
    )
    if (is.null(df)) {
      df <- this_df
    } else {
      df <- rbind(df, this_df)
    }
  }
  df
}
