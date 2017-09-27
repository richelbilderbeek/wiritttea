context("collect_files_parameters")

test_that("collect_files_parameters: use", {
  # Testing
  filenames <- find_paths(paste0("toy_example_", seq(1, 4), ".RDa"))
  df <- collect_files_parameters(filenames = filenames)
})

test_that("collect_files_parameters: invalid file return an empty data.frame", {

  filenames <- c("inva.lid")
  df <- wiritttea::collect_files_parameters(filenames = filenames)
  testthat::expect_equal(class(df), "data.frame")
  testthat::expect_equal(nrow(df), length(filenames))
})

test_that("collect_files_parameters: abuse", {

  # Create a 'corrupt file'
  filename <- "test-collect_files_parameters.RDa"
  cat("I am not a valid file\n", file = filename)

  df <- collect_files_parameters(
    filenames = c(
      filename,
      find_path("toy_example_1.RDa")
    )
  )
  # One row per file
  testthat::expect_equal(nrow(df), 2)

  # File one has only NAs
  testthat::expect_true(is.na(df[1, "rng_seed"]))

  # File two (a toy example) is valid
  testthat::expect_false(is.na(df[2, "rng_seed"]))
  file.remove(filename)
})

# Checks a refactoring
test_that("collect_files_parameters: is add_outgroup really gone?", {
  # Testing
  filenames <- paste0("collect_files_parameters_", seq(1, 4), ".RDa")
  wiritttes::create_test_parameter_files(filenames = filenames)
  for (filename in filenames) {
    file <- wiritttes::read_file(filename)
    expect_true("rng_seed" %in% names(file$parameters[2, , 2]))
    expect_false("add_outgroup" %in% names(file$parameters[2, , 2]))
  }
  file.remove(filenames)
})
