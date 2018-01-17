context("create_figure_error_mean_dur_spec")

test_that("works", {

  skip("Decrease sample")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_figure_error_mean_dur_spec(
      parameters = wiritttea::read_collected_parameters(),
      nltt_stats = wiritttea::read_collected_nltt_stats(burn_in_fraction = 0.2),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
