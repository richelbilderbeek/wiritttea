context("collect_file_posterior_crown_ages")

test_that("basic use", {

  filename <- wiritttea::find_path("toy_example_3.RDa")
  df <- wiritttea::collect_file_posterior_crown_ages(filename)
  testthat::expect_equal(
    names(df),
    c("sti", "ai", "pi", "si", "crown_age")
  )
  testthat::expect_true(nrow(df) == 88)
})
