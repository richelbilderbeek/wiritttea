context("create_figure_error_alignment_length")

test_that("works", {

  filename <- tempfile(
    pattern = "figure_error_alignment_length_",
    fileext = ".svg")

  testthat::expect_false(file.exists(filename))
  parameters <- wiritttea::read_collected_parameters()
  nltt_stats <- wiritttea::read_collected_nltt_stats(burn_in_fraction = 0.2)
  create_figure_error_alignment_length(
    parameters = parameters,
    nltt_stats = nltt_stats,
    filename = filename
  )
  testthat::expect_true(file.exists(filename))

})
