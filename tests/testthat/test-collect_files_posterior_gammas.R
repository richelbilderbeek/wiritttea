context("collect_files_posterior_gammas")

test_that("collect_files_posterior_gammas: use", {

  filenames <- c(
    find_path("toy_example_3.RDa"),
    find_path("toy_example_4.RDa")
  )
  df <- collect_files_posterior_gammas(filenames)
  expect_equal(
    names(df),
    c("filename", "sti", "gamma_stat")
  )
  expect_equal(nrow(df), 160)
})

test_that("collect_files_posterior_gammas: abuse", {

  expect_error(
    collect_files_posterior_gammas(filenames = c()),
    "there must be at least one filename supplied"
  )
})
