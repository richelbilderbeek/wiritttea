context("collect_files_strees_identical")

test_that("use", {

 filenames <- c(
   wiritttes::find_path("toy_example_3.RDa"),
   wiritttes::find_path("toy_example_4.RDa")
 )
 df <- wiritttea::collect_files_strees_identical(filenames)
 testthat::expect_equal(
   names(df), c("filename", "strees_identical")
 )
 testthat::expect_equal(nrow(df), 2)
 testthat::expect_equal(df$strees_identical[1], TRUE)
 testthat::expect_equal(df$strees_identical[2], FALSE)
})
