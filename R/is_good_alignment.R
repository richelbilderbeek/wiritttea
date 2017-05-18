#' Checks if an alignment is good enough
#' @param alignment A DNA alignment, assumed to be created by the
#'   Jukes-Cantor 1969 nucleotide substitution model
#' @return TRUE or FALSE
#' @export
#' @author Richel Bilderbeek
is_good_alignment <- function(
  alignment
) {
  if (!ribir::is_alignment(alignment)) {
    stop("Argument 'alignmnet' is not an alignment")
  }
  m <- ape::dist.dna(x = alignment, model = "JC69", as.matrix = TRUE)

  # Detect if there is at least one NA
  if (!all(!is.na(m))) {
    return(FALSE)
  }
  # Detect zeroes, except those on the diagonal
  if (sum(m == 0.0) - nrow(m) > 0) {
    return(FALSE)
  }
  return(TRUE)
}
