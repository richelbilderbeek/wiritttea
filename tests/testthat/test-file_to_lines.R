context("file_to_lines")

test_that("example code", {
  text <- wiritttea::file_to_lines(filename = wiritttea::find_path("add_alignments_ok.log"))
  testthat::expect_equal(length(text), 50)
})
