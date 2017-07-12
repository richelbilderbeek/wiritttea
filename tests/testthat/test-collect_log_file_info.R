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

test_that("Unknown error", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("article_0_1_0_0_1_248_2_1_2.log"))
  testthat::expect_equal(df$exit_status[1], "memory")
})



