context("create_figure_error_tree_size")

test_that("works", {

  skip("Decrease sample")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_error_tree_size(
      n_taxa = wiritttea::read_collected_n_taxa(),
      nltt_stats = read_collected_nltt_stats(burn_in_fraction = 0.1),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))

})
