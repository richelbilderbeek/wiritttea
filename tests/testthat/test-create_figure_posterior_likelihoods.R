context("create_figure_posterior_likelihoods")

test_that("use", {

  skip("Add read_collected_posterior_likelihoods")

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    create_figure_posterior_likelihoods(
      # posterior_likelihoods = read_collected_posterior_likelihoods
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
