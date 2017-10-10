context("create_table_111")

test_that("multiplication works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    create_table_111(
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
