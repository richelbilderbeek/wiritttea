context("collect_files_posterior_crown_ages")

test_that("Basic use", {

  filenames <- wiritttea::find_paths(
    c("toy_example_1.RDa", "toy_example_2.RDa",
    "toy_example_3.RDa", "toy_example_4.RDa")
  )
  df <- wiritttea::collect_files_pstr_crown_ages(filenames)
  testthat::expect_equal(
    names(df),
    c("filename", "sti", "ai", "pi", "si", "crown_age")
  )

  # Generation of file
  need_to_recreate <- FALSE
  if (need_to_recreate == TRUE) {
    write.csv(df, "~/collect_files_posterior_crown_ages.csv")
  }

  testthat::expect_true(nrow(df) == 220)
})
