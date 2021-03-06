context("collect_file_stree_nltts")

test_that("collect_file_stree_nltts: toy example 1", {
  filename <- wiritttea::find_path("toy_example_1.RDa")
  dt <- 0.1
  df <- wiritttea::collect_file_stree_nltts(filename = filename, dt = dt)
  testthat::expect_equal(names(df), c("sti", "t", "nltt"))
  testthat::expect_true(tail(df$nltt, n = 1) > 0.8)
})

test_that("collect_file_stree_nltts: toy example 2", {
  filename <- find_path("toy_example_2.RDa")
  dt <- 0.1
  df <- wiritttea::collect_file_stree_nltts(filename = filename, dt = dt)
  testthat::expect_true(tail(df$nltt, n = 1) > 0.8)
})

test_that("collect_file_stree_nltts: abuse", {

  testthat::expect_error(
    wiritttea::collect_file_stree_nltts(filename = "inva.lid", dt = 0.1),
    "invalid file"
  )

})
