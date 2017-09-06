context("collect_files_posterior_nltts")

test_that("Basic use", {

  filenames <- wiritttea::find_paths(
    c("toy_example_1.RDa", "toy_example_2.RDa",
    "toy_example_3.RDa", "toy_example_4.RDa")
  )
  df <- wiritttea::collect_files_posterior_nltts(filenames)
  testthat::expect_equal(
    names(df),
    c("filename", "sti", "ai", "pi", "si", "nltt")
  )

  # write.csv(df, "~/collect_files_posterior_likelihoods.csv")

  testthat::expect_true(nrow(df) > 10)
})
