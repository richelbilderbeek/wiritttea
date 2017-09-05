context("collect_files_posterior_likelihoods")

test_that("multiplication works", {

  filenames <- wiritttea::find_paths(
    c("toy_example_3.RDa", "toy_example_4.RDa"))
  df <- wiritttea::collect_files_posterior_likelihoods(filenames)
  testthat::expect_equal(
    names(df),
    c("filename", "sti", "ai", "pi", "si", "likelihood")
  )

  testthat::expect_true(nrow(df) > 10)
})
