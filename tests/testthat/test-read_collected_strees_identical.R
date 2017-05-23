context("read_collected_strees_identical")

test_that("use", {

  csv_filename <- wiritttea::find_path("collect_files_strees_identical.csv")
  strees_identical <- wiritttea::read_collected_strees_identical(csv_filename)
  testthat::expect_equal(names(df), c(
    "filename", "strees_identical"
    )
  )
  testthat::expect_true(is.factor(df$filename))
  testthat::expect_true(is.factor(df$strees_identical))
})
