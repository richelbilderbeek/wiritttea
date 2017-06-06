#' Calculates the Distance Matrix Information Density, which is the
#' proportion of non-diagonal elements in a distance matrix having
#' non-zero and non-NA values
#'
#' @param distance_matrix a distance matrix, a numeric matrix.
#' @return the DMID
#' @examples
#'   # Create a random phylogeny
#'   set.seed(43)
#'   n_taxa <- 5
#'   phylogeny <- ape::rcoal(n = n_taxa)
#'
#'   # Create a random DNA alignment from the phylogeny
#'   sequence_length <- 20 # nucleotides
#'   mutation_rate <- 0.5 # mutations per nucleotide per unit of time
#'   alignment_phydat <- phangorn::simSeq(
#'     phylogeny, l = sequence_length, rate = mutation_rate)
#'   alignment_dnabin <- ape::as.DNAbin(alignment_phydat)
#'
#'   # Create a distance matrix from the alignment
#'   distance_matrix <- ape::dist.dna(
#'     x = alignment_dnabin, model = "JC69", as.matrix = TRUE)
#'
#'   # Because all non-diagonal elements of the matrix are non-zero and
#'   # non-NA, the DMID is 1.0
#'   testit::assert(wiritttea::calc_dmid(distance_matrix) > 0.999)
#'   testit::assert(wiritttea::calc_dmid(distance_matrix) < 1.001)
#' @export
calc_dmid <- function(distance_matrix) {

  n_informative <- Matrix::nnzero(distance_matrix, na.counted = FALSE)
  n_non_diagonals <- length(distance_matrix) - ncol(distance_matrix)
  dmid <- n_informative / n_non_diagonals
  dmid
}
