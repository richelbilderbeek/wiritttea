context("collect_files_alignments")

test_that("example use", {

  filenames <- wiritttea::find_paths(
    c("toy_example_3.RDa", "toy_example_4.RDa"))
  df <- wiritttea::collect_files_alignments(filenames)
  testthat::expect_equal(nrow(df),  2)
  expected_names <- c("filename", "n_alignments_ok", "n_alignments_zeroes",
    "n_alignments_na")
  testthat::expect_true(all.equal(names(df), expected_names))
})
