context("collect_file_nltts")

test_that("collect_file_nltts: use", {
  dt <- 0.1
  filename <- wiritttea::find_path("toy_example_3.RDa")
  df <- wiritttea::collect_file_nltts(filename, dt = dt)
  testthat::expect_equal(
    names(df),
    c("species_tree_nltts", "posterior_nltts")
  )
  testthat::expect_equal(
    names(df$species_tree_nltts),
    c("sti", "t", "nltt")
  )
  testthat::expect_true(nrow(df$species_tree_nltts) > 2)
  testthat::expect_equal(object = nrow(df$posterior_nltts), expected = 80)
})

test_that("collect_file_nltts: abuse", {

  expect_error(
    collect_file_nltts(filename = c("inva", "lid")),
    "there must be exactly one filename supplied"
  )

  expect_error(
    collect_file_nltts(filename = "inva.lid"),
    "invalid file '"
  )

})
