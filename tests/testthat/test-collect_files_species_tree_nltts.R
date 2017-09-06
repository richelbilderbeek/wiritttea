context("collect_files_stree_nltts")

test_that("basic", {
  filenames <- c(
    find_path("toy_example_1.RDa"),
    find_path("toy_example_2.RDa"),
    find_path("toy_example_3.RDa"),
    find_path("toy_example_4.RDa")
  )

  df <- collect_files_stree_nltts(filenames, dt = 0.5)

  expect_equal(nrow(df), 24)

  expect_true(
    identical(
      names(df),
      c("filename", "sti", "t", "nltt")
    )
  )

})


test_that("collect_files_stree_nltts: abuse", {

  expect_error(
    collect_files_stree_nltts(filenames = c()),
    "there must be at least one filename supplied"
  )

})
