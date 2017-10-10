context("create_figure_acceptance_mcmc_operators")

test_that("works", {

  svg_filename <- tempfile(pattern = "figure__acceptance_mcmc_operators_", fileext = ".svg")
  testthat::expect_false(file.exists(svg_filename))
  df_operators <- wiritttea::read_collected_operators()
  wiritttea::create_figure_acceptance_mcmc_operators(
    df_operators = df_operators,
    svg_filename = svg_filename
  )
  testthat::expect_true(file.exists(svg_filename))
})
