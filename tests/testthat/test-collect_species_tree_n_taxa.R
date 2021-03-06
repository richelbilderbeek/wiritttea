context("collect_species_tree_n_taxa")

test_that("collect_species_tree_n_taxa: basic use", {

  filename <- find_path("toy_example_1.RDa")
  df <- collect_species_tree_n_taxa(filename)
  expect_equal(names(df), c("n_taxa"))
  expect_equal(ncol(df), 1)
  expect_equal(nrow(df), 1)
})

test_that("collect_species_tree_n_taxa: abuse", {

  expect_error(
    collect_species_tree_n_taxa(
      filename = "inva.lid"
    ),
    "invalid file"
  )

})

test_that("collect_species_tree_n_taxa: empty file should raise error", {

  filename <- "test-collect_species_tree_n_taxa.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.1,
    siri = 0.1,
    scr = 0.1,
    erg = 0.1,
    eri = 0.1,
    age = 15,
    mutation_rate = 0.01,
    n_alignments = 2,
    sequence_length = 1000,
    nspp = 10,
    n_beast_runs = 2,
    filename = filename
  )

  # Mute output
  sink("/dev/null") # nolint
  df <- collect_species_tree_n_taxa(filename = filename)
  sink() # nolint

  expect_true(is.na(df$n_taxa[1]))
  file.remove(filename)
})
