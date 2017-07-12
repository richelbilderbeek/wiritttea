context("file_to_lines")

test_that("example code", {
  text <- wiritttea::file_to_lines(filename = wiritttea::find_path("add_alignments_ok.log"))
  testthat::expect_equal(length(text), 50)
})

test_that("Support files that have no empty line at the end", {
  text <- wiritttea::file_to_lines(
  filename = wiritttea::find_path("article_no_newline.log"))
  testthat::expect_equal(length(text), 900)

})
