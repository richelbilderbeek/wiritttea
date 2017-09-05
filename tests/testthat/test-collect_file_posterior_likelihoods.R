context("collect_file_posterior_likelihoods")

test_that("basic use", {

  filename <- wiritttea::find_path("toy_example_3.RDa")
  df <- wiritttea::collect_file_posterior_likelihoods(filename)
  testthat::expect_equal(
    names(df),
    c("sti", "ai", "pi", "si", "likelihood")
  )
  testthat::expect_true(nrow(df) == 88)
})
