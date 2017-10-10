context("create_figure_error_low_high_ess")

test_that("works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_error_low_high_ess(
      parameters = wiritttea::read_collected_parameters(),
      esses = wiritttea::read_collected_esses(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
