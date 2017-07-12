context("collect_log_file_info")

test_that("OK alignment file", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_alignments_ok.log"))
  testthat::expect_true(is.factor(df$exit_status))
  testthat::expect_equal(df$exit_status[1], as.factor("OK"))
})

test_that("Alignment file: exceeds memory", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_alignments_exceeded_memory.log"))
  testthat::expect_true(is.factor(df$exit_status))
  testthat::expect_equal(df$exit_status[1], as.factor("memory"))
})


