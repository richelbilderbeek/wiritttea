context("collect_file_posterior_gammas")

test_that("collect_file_posterior_gammas: use", {
  filename <- find_path("toy_example_3.RDa")
  df <- collect_file_posterior_gammas(filename)
  expect_equal(
    names(df),
    c("sti", "ai", "pi", "gamma_stat")
  )
  expect_equal(nrow(df), 80)
})

test_that("collect_file_posterior_gammas: abuse", {

  expect_error(
    collect_file_posterior_gammas(filename = "inva.lid"),
    "invalid file"
  )

})
