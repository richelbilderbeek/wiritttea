context("create_log_filenames")

test_that("example", {

  rda_filename <- "test.RDa"
  log_filenames <- wiritttea::create_log_filenames(rda_filename, 2,2,2)
  testit::assert(log_filenames[1] == "test_1_1_1.log")
  testit::assert(log_filenames[2] == "test_1_1_2.log")
  testit::assert(log_filenames[3] == "test_1_2_1.log")
  testit::assert(log_filenames[4] == "test_1_2_2.log")
  testit::assert(log_filenames[5] == "test_2_1_1.log")
  testit::assert(log_filenames[6] == "test_2_1_2.log")
  testit::assert(log_filenames[7] == "test_2_2_1.log")
  testit::assert(log_filenames[8] == "test_2_2_2.log")

})
