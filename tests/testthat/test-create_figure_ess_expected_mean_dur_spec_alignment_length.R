context("create_figure_ess_expected_mean_dur_spec_alignment_length")

test_that("multiplication works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_ess_expected_mean_dur_spec_alignment_length(
      parameters = wiritttea::read_collected_parameters(),
      esses = wiritttea::read_collected_esses(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
