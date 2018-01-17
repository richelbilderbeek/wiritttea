context("create_figure_posterior_nltts")

test_that("use", {

  skip("WIP")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_figure_posterior_nltts(
      filename = filename,
      nltt_stats = read_collected_nltts_postrs()
    )
  )

  testthat::expect_true(file.exists(filename))
})
