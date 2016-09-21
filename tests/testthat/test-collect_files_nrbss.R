context("collect_files_nrbss")

test_that("collect_files_nrbss: use", {

  filenames <- c(
    find_path("toy_example_3.RDa"),
    find_path("toy_example_4.RDa")
  )
  df <- collect_files_nrbss(filenames)
  expect_equal(
    names(df),
    c("filename", "sti", "ai", "pi", "si", "nrbs")
  )
  expect_equal(nrow(df), 160)
})

test_that("collect_files_nrbss: abuse", {

  expect_error(
    collect_files_nrbss(filenames = c()),
    "there must be at least one filename supplied"
  )
})
