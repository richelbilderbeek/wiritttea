context("create_figure_posterior_crown_ages")

test_that("use", {

  filename <- tempfile(pattern = "figure_", fileext = ".svg")
  testthat::expect_false(file.exists(filename))

  testthat::expect_silent(
    create_figure_posterior_crown_ages(
      posterior_crown_ages = read_collected_pstr_crown_ages(),
      filename = filename
    )
  )

  testthat::expect_true(file.exists(filename))
})
