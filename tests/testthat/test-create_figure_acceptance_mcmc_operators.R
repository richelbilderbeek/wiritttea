context("create_figure_acceptance_mcmc_operators")

test_that("works", {

  filename <- tempfile(pattern = "figure__acceptance_mcmc_operators_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))
  operators <- wiritttea::read_collected_operators()
  wiritttea::create_figure_acceptance_mcmc_operators(
    operators = operators,
    filename = filename
  )
  testthat::expect_true(file.exists(filename))
})
