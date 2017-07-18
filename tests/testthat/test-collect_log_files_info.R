context("collect_log_files_info")

test_that("example", {

    filenames <- c(
     find_path("add_alignments_ok.log"),
     find_path("add_alignments_exceeded_memory.log")
   )
   df <- collect_log_files_info(filenames)
   testthat::expect_true("filename" %in% names(df))
   testthat::expect_true("exit_status" %in% names(df))
   testthat::expect_true("sys_time" %in% names(df))
   testthat::expect_equal(nrow(df), length(filenames))
   testthat::expect_true(df$exit_status[1] != df$exit_status[2])
})
