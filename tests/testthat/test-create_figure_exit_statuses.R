context("create_figure_exit_statuses")

test_that("multiplication works", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    wiritttea::create_figure_exit_statuses(
      log_files_info = wiritttea::read_collected_log_files_info(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
