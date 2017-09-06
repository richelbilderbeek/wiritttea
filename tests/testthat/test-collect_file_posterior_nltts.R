context("collect_file_posterior_nltts")


test_that("use", {
  filename <- wiritttea::find_path("toy_example_3.RDa")
  df <- wiritttea::collect_file_posterior_nltts(filename)
  testthat::expect_equal(
    names(df),
    c("sti", "ai", "pi", "si", "nltt")
  )
  testthat::expect_true(nrow(df) == 80)
})
