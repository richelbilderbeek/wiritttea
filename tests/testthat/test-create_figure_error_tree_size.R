context("create_figure_error_tree_size")

test_that("works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_error_tree_size(
      parameters = wiritttea::read_collected_parameters(),
      n_taxa = wiritttea::read_collected_n_taxa(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))

})
