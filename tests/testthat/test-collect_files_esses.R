context("collect_files_esses")

test_that("collect_files_esses: use", {
  filenames <- find_paths(c("toy_example_3.RDa", "toy_example_4.RDa"))
  df <- wiritttea::collect_files_esses(filenames)
  testthat::expect_equal(nrow(df), 16)
})

test_that("only invalid file fails", {

  filename <- find_path("collect_files_esses_invalid.RDa")
  testthat::expect_error(collect_files_esses(filename))
})

test_that("valid and invalid file works", {

  filenames <- find_paths(c("toy_example_3.RDa", "collect_files_esses_invalid.RDa"))
  df <- collect_files_esses(filenames)
  testthat::expect_equal(nrow(df), 16)
})

test_that("invalid and valid file works", {

  filenames <- find_paths(c("collect_files_esses_invalid.RDa", "toy_example_3.RDa"))
  df <- collect_files_esses(filenames)
  testthat::expect_equal(nrow(df), 16)
})
