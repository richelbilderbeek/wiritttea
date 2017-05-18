context("is_good_alignment")

test_that("is_good_alignment: good alignment", {

  filename <- "test-is_good_alignment.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.5,
    siri = 0.5,
    scr = 0.5,
    erg = 0.5,
    eri = 0.5,
    age = 5,
    mutation_rate = 0.1,
    n_alignments = 1,
    sequence_length = 10,
    nspp = 10,
    n_beast_runs = 1,
    filename = filename
  )
  wiritttes::add_pbd_output(filename)
  wiritttes::add_species_trees(filename = filename)
  wiritttes::add_alignments(filename = filename)

  # Alignment is OK
  alignment <- wiritttes::get_alignment(
    wiritttes::read_file(filename = filename), sti = 1, ai = 1)
  testthat::expect_true(wiritttea::is_good_alignment(alignment))

  # Cleaning up
  file.remove(filename)
  testthat::expect_false(file.exists(filename))

})

test_that("is_good_alignment: bad alignment, due to low mutation rate", {

  filename <- "test-is_good_alignment.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.5,
    siri = 0.5,
    scr = 0.5,
    erg = 0.5,
    eri = 0.5,
    age = 5,
    mutation_rate = 1E-99, #Cannot be zero
    n_alignments = 1,
    sequence_length = 10,
    nspp = 10,
    n_beast_runs = 1,
    filename = filename
  )
  testit::assert(wiritttes::is_valid_file(filename))
  wiritttes::add_pbd_output(filename)
  wiritttes::add_species_trees(filename = filename)
  wiritttes::add_alignments(filename = filename)

  # Alignment is bad
  alignment <- wiritttes::get_alignment(
    wiritttes::read_file(filename = filename), sti = 1, ai = 1)
  testthat::expect_false(wiritttea::is_good_alignment(alignment))

  # Cleaning up
  file.remove(filename)
  testthat::expect_false(file.exists(filename))

})

test_that("is_good_alignment: bad alignment, due to high mutation rate", {

  filename <- "test-is_good_alignment.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.5,
    siri = 0.5,
    scr = 0.5,
    erg = 0.5,
    eri = 0.5,
    age = 5,
    mutation_rate = 10.0,
    n_alignments = 1,
    sequence_length = 10,
    nspp = 10,
    n_beast_runs = 1,
    filename = filename
  )
  wiritttes::add_pbd_output(filename)
  wiritttes::add_species_trees(filename = filename)
  wiritttes::add_alignments(filename = filename)

  # Alignment is bad
  alignment <- wiritttes::get_alignment(
    wiritttes::read_file(filename = filename), sti = 1, ai = 1)
  testthat::expect_false(wiritttea::is_good_alignment(alignment))

  # Cleaning up
  file.remove(filename)
  testthat::expect_false(file.exists(filename))

})
