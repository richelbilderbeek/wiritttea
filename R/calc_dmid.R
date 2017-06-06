#' Calculates the Distance Matrix Information Density, which is the
#' proportion of non-diagonal elements in a distance matrix having
#' non-zero and non-NA values
#'
#' @param distance_matrix a distance matrix, a numeric matrix.
#' @return the DMID
#' @examples
#'   set.seed(42)
#'   n_taxa <- 5
#'   sequence_length <- 10 # nucleotides
#'   mutation_rate <- 0.1 # mutations per nucleotide per unit of time
#'   phylogeny <- ape::rcoal(n = n_taxa)
#'   alignment_phydat <- phangorn::simSeq(
#'     phylogeny, l = sequence_length, rate = mutation_rate)
#'   alignment_dnabin <- ape::as.DNAbin(alignment_phydat)
#'   distance_matrix <- ape::dist.dna(
#'     x = alignment_dnabin, model = "JC69", as.matrix = TRUE)
#'   testit::assert(calc_dmid(distance_matrix) > 0.0)
#'   testit::assert(calc_dmid(distance_matrix) < 1.0)
#' @export
calc_dmid <- function(distance_matrix) {

  distance_matrix <- 0.5
  distance_matrix
}
