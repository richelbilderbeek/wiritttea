context("create_table_109")

test_that("use", {

  skip("Fix read_collected_log_files_info")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea:::create_table_109(
      log_files_info = read_collected_log_files_info(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
