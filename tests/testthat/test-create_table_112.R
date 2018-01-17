context("create_table_112")

test_that("use", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_table_112(
      filename = filename,
      esses = read_collected_esses()
    )
  )

  testthat::expect_true(file.exists(filename))
})
