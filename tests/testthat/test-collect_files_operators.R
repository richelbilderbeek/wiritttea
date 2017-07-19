context("collect_files_operators")

test_that("example", {

  df_operators <- collect_files_operators(
    filenames = rep(find_path("collect_files_operators.xml.state"), 2)
  )
  expected_names <- c("filename", "operator", "p", "accept", "reject", "acceptFC",
    "rejectFC", "rejectIv", "rejectOp")
  testthat::expect_equal(names(df_operators), expected_names)

  testthat::expect_equal(nrow(df_operators), 18)
})
