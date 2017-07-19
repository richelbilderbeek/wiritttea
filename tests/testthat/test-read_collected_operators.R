context("read_collected_operators")

test_that("example", {

  df <- wiritttea::read_collected_operators(
    wiritttea::find_path("read_collected_operators.csv"))
  testthat::expect_equal(nrow(df), 10)
})
