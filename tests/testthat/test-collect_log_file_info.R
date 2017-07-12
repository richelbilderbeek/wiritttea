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

test_that("Cannot read FASTA file", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_cannot_read_fasta.log"))
  testthat::expect_equal(df$exit_status[1], "fasta")
})

test_that("add_posteriors encounters an invalid file", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_invalid_file.log"))
  testthat::expect_equal(df$exit_status[1], "invalid_file")
})

test_that("add_posteriors has absent BEAST2 .trees file", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_trees_file_absent.log"))
  testthat::expect_equal(df$exit_status[1], "trees")
})

test_that("add_posteriors has FASTA file I/O error", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_fasta_io_error.log"))
  testthat::expect_equal(df$exit_status[1], "fasta_io")
})

test_that("add_posteriors has incorrect alignment", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_incorrect_alignment.log"))
  testthat::expect_equal(df$exit_status[1], "alignment")
})

test_that("add_posteriors saving posterior fails", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_save_posterior_failed.log"))
  testthat::expect_equal(df$exit_status[1], "save_posterior")
})

test_that("add_posteriors read sequence is no DNAbin", {
  df <- wiritttea::collect_log_file_info(
    filename = wiritttea::find_path("add_posteriors_sequence_no_dnabin.log"))
  testthat::expect_equal(df$exit_status[1], "no_dnabin")
})













