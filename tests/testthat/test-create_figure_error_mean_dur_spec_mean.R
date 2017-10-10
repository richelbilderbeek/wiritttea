context("create_figure_error_mean_dur_spec_mean")

test_that("multiplication works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    create_figure_error_mean_dur_spec_mean(
      parameters = wiritttea::read_collected_parameters(),
      nltt_stats = wiritttea::read_collected_nltt_stats(burn_in_fraction = 0.2),
      filename = filename

    )
  )

  testthat::expect_true(file.exists(filename))
})
