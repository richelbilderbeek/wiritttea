context("create_figure_posterior_nltts")

test_that("multiplication works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    create_figure_posterior_nltts(
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
