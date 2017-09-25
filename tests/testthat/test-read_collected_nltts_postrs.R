context("read_collected_nltts_postrs")

test_that("use", {
  df <- wiritttea::read_collected_nltts_postrs()
  testthat::expect_identical(object = names(df),
    expected =
    c(
      "filename", "sti", "ai",
      "pi", "si", "nltt"
    )
  )
})
