context("collect_file_esses")

test_that("collect_file_esses: use", {

  filename <- find_path("toy_example_4.RDa")
  df <- collect_file_esses(filename)
  testthat::expect_equal(nrow(df), 8)
  testthat::expect_true(df$birthRate2[1] != df$birthRate2[2])
})

test_that("invalid file", {

  filename <- find_path("collect_files_esses_invalid.RDa")
  df <- NA
  tryCatch(
    df <- collect_file_esses(filename),
    error = function(cond) {} # nolint
  )
  testthat::expect_true(!is.data.frame(df))
})
