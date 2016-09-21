context("file_has_valid_parameters")


test_that("file_has_valid_parameters: use", {
  expect_true(
    file_has_valid_parameters(
      read_file(
        find_path("toy_example_1.RDa")
      )
    )
  )
})

test_that("file_has_valid_parameters: abuse", {

  # ERG
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$erg <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # ERI
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$eri <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )


  # SCR
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$scr <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # SIRG
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$sirg <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # SIRI
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$siri <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # add_outgroup
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$add_ougroup <- "present"
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # age
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$age[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # mutation rate
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$mutation_rate[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )
  # n_alignments
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$n_alignments[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # sequence_length
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$sequence_length[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # n_beast_runs
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$n_beast_runs[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

  # nspp
  file <- read_file(find_path("toy_example_1.RDa"))
  file$parameters$nspp[2] <- -123.456
  expect_false(
    file_has_valid_parameters(file = file)
  )

})
