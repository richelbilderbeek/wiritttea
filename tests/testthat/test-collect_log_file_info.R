context("collect_log_file_info")

test_that("OK alignment file", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_alignments_ok.log"))
  testthat::expect_equal(df$exit_status[1], "OK")
})

test_that("Alignment file: exceeds memory", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_alignments_exceeded_memory.log"))
  testthat::expect_equal(df$exit_status[1], "memory")
})

test_that("No newline", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("article_no_newline.log"))
  testthat::expect_equal(df$exit_status[1], "OK")
})

test_that("Died by signal", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_died_by_signal.log"))
  testthat::expect_equal(df$exit_status[1], "died")
})





