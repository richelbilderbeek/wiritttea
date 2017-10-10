context("create_figure_error_alignment_length_median")

test_that("works", {

  parameters <- wiritttea::read_collected_parameters()
  nltt_stats <- wiritttea::read_collected_nltt_stats(burn_in_fraction = 0.2)
  esses <- wiritttea::read_collected_esses()
  filename <- tempfile(pattern = "figure_error_alignment_length_median_",
    fileext = ".svg")

  testthat::expect_false(file.exists(filename))
  create_figure_error_alignment_length_median(
    parameters = parameters,
    nltt_stats = nltt_stats,
    esses = esses,
    filename = filename
  )
  testthat::expect_true(file.exists(filename))

})
