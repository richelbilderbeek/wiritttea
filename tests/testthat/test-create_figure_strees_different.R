context("create_figure_strees_different")

test_that("use", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_figure_strees_different(
      strees_identical = read_collected_strees_identical(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
