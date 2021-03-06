context("collect_files_n_species_trees")

test_that("collect_files_n_species_trees: basic use", {
  filenames <- c(
    find_path("toy_example_1.RDa"),
    find_path("toy_example_3.RDa")
  )
  df <- collect_files_n_species_trees(filenames)
  expect_equal(names(df), c("filename", "n_species_trees"))
  expect_equal(nrow(df), length(filenames))
  expect_equal(df$n_species_trees, c(2, 2))
})

test_that("collect_files_n_species_trees: abuse", {

  expect_error(
    collect_files_n_species_trees(filename = c()),
    "there must be at least one filename supplied" # nolint
  )
})
