context("create_figure_error_low_high_ess_mean")

test_that("works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_error_low_high_ess_mean(
      parameters = wiritttea::read_collected_parameters(),
      nltt_stats = wiritttea::read_collected_nltt_stats(burn_in_fraction = 0.2),
      esses = wiritttea::read_collected_esses(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
