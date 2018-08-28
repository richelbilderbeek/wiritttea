context("create_figure_error")

test_that("example", {

  filename <- tempfile(pattern = "figure_error_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))
  parameters <- wiritttea::read_collected_parameters()
  nltt_stats <- wiritttea::read_collected_nltt_stats(burn_in = 0.2)
  testthat::expect_silent(
    wiritttea::create_figure_error(
      parameters = parameters,
      nltt_stats = nltt_stats,
      filename = filename,
      verbose = FALSE
    )
  )
  testthat::expect_true(file.exists(filename))
})
