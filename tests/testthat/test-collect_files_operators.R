context("collect_files_operators")

test_that("example", {

  df_operators <- wiritttea::collect_files_operators(
    filenames = rep(wiritttea::find_path("collect_files_operators.xml.state"), 2)
  )
  expected_names <- c("filename", "operator", "p", "accept", "reject", "acceptFC",
    "rejectFC", "rejectIv", "rejectOp")
  testthat::expect_equal(names(df_operators), expected_names)

  testthat::expect_equal(nrow(df_operators), 18)
})

test_that("good and empty file", {

  df_operators <- wiritttea::collect_files_operators(
    filenames =
      wiritttea::find_paths(
        c("collect_files_operators.xml.state", "collect_files_operators_empty.xml.state"))

  )
  #write.csv(df_operators, "~/read_collected_operators.csv")

  testthat::expect_equal(nrow(df_operators), 10)
})
