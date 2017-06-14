context("collect_files_nltt_stats")

test_that("collect_files_nltt_stats: use", {
  nltt_stats <- collect_files_nltt_stats(
    filenames = c(
      find_path("toy_example_1.RDa"),
      find_path("toy_example_2.RDa")
    )
  )
  expected_names <- c("filename", "sti", "ai", "pi", "si", "nltt_stat")
  expect_identical(names(nltt_stats), expected_names)
})

test_that("collect_files_nltt_stats: fix #112", {
  filename <- find_path("toy_example_1.RDa")
  nltt_stats <- collect_files_nltt_stats(
    filenames = c(filename)
  )
  # The tenth posterior always has an nLTT statistics of 0.0,
  # unless the file has not calculated the posteriors.
  # If the latter is the case, nltt_stat will be NA
  expect_true(sum(nltt_stats[nltt_stats$si == 10, ]$nltt_stat) > 0)
})


test_that("collect_files_nltt_stats: abuse", {

  testthat::expect_error(
    wiritttea::collect_files_nltt_stats(filenames = c("inva.lid")),
    "invalid file "
  )
})

test_that("collect_files_nltt_stats_dirty: use on one", {

  df <- wiritttea::collect_files_nltt_stats_dirty(filenames = c("inva.lid"))
  testthat::expect_equal(nrow(df), 1)
  testthat::expect_true(df$filename[1] == "inva.lid")
  testthat::expect_true(is.na(df$sti))
})

test_that("collect_files_nltt_stats_dirty: use on three", {

  df <- wiritttea::collect_files_nltt_stats_dirty(
    filenames = c(
      find_path("toy_example_1.RDa"),
      "inva.lid",
      find_path("toy_example_2.RDa")
    )
  )
  testthat::expect_equal(nrow(df), 41)
  testthat::expect_true(df$filename[41] == "inva.lid")
  testthat::expect_true(is.na(df$sti[41]))
})
