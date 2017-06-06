context("calc_dmid")

test_that("example", {

  # Create a random phylogeny
  set.seed(43)
  n_taxa <- 5
  phylogeny <- ape::rcoal(n = n_taxa)

  # Create a random DNA alignment from the phylogeny
  sequence_length <- 20 # nucleotides
  mutation_rate <- 0.5 # mutations per nucleotide per unit of time
  alignment_phydat <- phangorn::simSeq(
    phylogeny, l = sequence_length, rate = mutation_rate)
  alignment_dnabin <- ape::as.DNAbin(alignment_phydat)

  # Create a distance matrix from the alignment
  distance_matrix <- ape::dist.dna(
    x = alignment_dnabin, model = "JC69", as.matrix = TRUE)

  # Because all non-diagonal elements of the matrix are non-zero and
  # non-NA, the DMID is 1.0
  testthat::expect_gt(wiritttea::calc_dmid(distance_matrix), 0.999)
  testthat::expect_lt(wiritttea::calc_dmid(distance_matrix), 1.001)

})

test_that("no mutation, thus DMID is 0.0", {

  set.seed(42)
  n_taxa <- 5
  sequence_length <- 10 # nucleotides
  mutation_rate <- 0.0 # mutations per nucleotide per unit of time
  phylogeny <- ape::rcoal(n = n_taxa)
  alignment_phydat <- phangorn::simSeq(
    phylogeny, l = sequence_length, rate = mutation_rate)
  alignment_dnabin <- ape::as.DNAbin(alignment_phydat)
  distance_matrix <- ape::dist.dna(
    x = alignment_dnabin, model = "JC69", as.matrix = TRUE)
  testthat::expect_lt(calc_dmid(distance_matrix), 0.0001)
})
