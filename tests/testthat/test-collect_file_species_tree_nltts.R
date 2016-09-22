context("collect_file_species_tree_nltts")

test_that("collect_file_species_tree_nltts: toy example 1", {
  filename <- find_path("toy_example_1.RDa")
  dt <- 0.1
  df <- collect_file_species_tree_nltts(filename = filename, dt = dt)
  expect_equal(names(df), c("sti", "t", "nltt"))
  expect_true(tail(df$nltt, n = 1) > 0.8)
})

test_that("collect_file_species_tree_nltts: toy example 2", {
  filename <- find_path("toy_example_2.RDa")
  dt <- 0.1
  df <- collect_file_species_tree_nltts(filename = filename, dt = dt)
  expect_true(tail(df$nltt, n = 1) > 0.8)
})

test_that("collect_file_species_tree_nltts: abuse", {

  expect_error(
    collect_file_species_tree_nltts(filename = "inva.lid", dt = 0.1),
    "invalid file"
  )

})
