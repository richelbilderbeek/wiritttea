context("have_same_strees")

## TODO: Rename context
## TODO: Add more tests

test_that("have_same_strees use: create identical trees", {

  # Create a parameter file
  filename <- "test-have_same_strees.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.5,
    siri = 0.5,
    scr = 1.0E10, # Big chance trees are equal
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

  # Simulate an incipient species tree
  wiritttes::add_pbd_output(filename)
  # Add the species trees
  wiritttes::add_species_trees(filename = filename)
  testit::assert(wiritttes::has_species_trees(wiritttes::read_file(filename)))

  # Probably equal
  testit::assert(wiritttea::have_same_strees(wiritttes::read_file(filename)))

})

test_that("have_same_strees use: create different trees", {

  # Create a parameter file
  filename <- "test-have_same_strees.RDa"
  wiritttes::save_parameters_to_file(
    rng_seed = 42,
    sirg = 0.5,
    siri = 0.5,
    scr = 1.0, # Lower chance trees are equal
    erg = 0.2,
    eri = 0.2,
    age = 5,
    mutation_rate = 0.1,
    n_alignments = 1,
    sequence_length = 10,
    nspp = 10,
    n_beast_runs = 1,
    filename = filename
  )

  # Simulate an incipient species tree
  wiritttes::add_pbd_output(filename)
  # Add the species trees
  wiritttes::add_species_trees(filename = filename)
  testit::assert(wiritttes::has_species_trees(wiritttes::read_file(filename)))

  # Check by hand here first that these are different
  stree_youngest <- wiritttes::get_species_tree_youngest(
    wiritttes::read_file(filename))
  stree_oldest <- wiritttes::get_species_tree_oldest(
    wiritttes::read_file(filename))
  testit::assert(
    !identical(
      sort(as.vector(ape::branching.times(stree_youngest))),
      sort(as.vector(ape::branching.times(stree_oldest)))
    )
  )

  # Probably equal
  testit::assert(!wiritttea::have_same_strees(wiritttes::read_file(filename)))

})
