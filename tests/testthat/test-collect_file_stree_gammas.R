context("collect_file_stree_gammas")

test_that("collect_file_stree_gammas toy example 1", {
  filename <- find_path("toy_example_1.RDa")
  df <- collect_file_stree_gammas(filename)
  expect_equal(names(df),
    c("sti", "gamma_stat")
  )
  expect_equal(nrow(df), 2)
  expect_false(is.na(df$gamma_stat[1]))
  expect_false(is.na(df$gamma_stat[2]))
})

test_that("collect_file_stree_gammas toy example 3", {
  filename <- find_path("toy_example_3.RDa")
  df <- collect_file_stree_gammas(filename)
  expect_equal(names(df),
    c("sti", "gamma_stat")
  )
  expect_equal(nrow(df), 2)
  expect_false(is.na(df$gamma_stat[1]))
  expect_false(is.na(df$gamma_stat[2]))
})

test_that("collect_file_stree_gammas: abuse", {

  expect_error(
    collect_file_stree_gammas(filename = "inva.lid"),
    "invalid file"
  )
})
