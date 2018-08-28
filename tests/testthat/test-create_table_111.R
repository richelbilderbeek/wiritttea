context("create_table_111")

test_that("use", {

  skip("Assumes one ESS, when there is 1 ESS per parameter")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_table_111(
      filename = filename,
      esses = read_collected_esses()
    )
  )

  testthat::expect_true(file.exists(filename))
})
