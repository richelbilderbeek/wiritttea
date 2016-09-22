context("collect_file_nltt_stats")

test_that("collect_file_nltt_stats: use", {
  nltt_stats <- collect_file_nltt_stats(
    filename = find_path("toy_example_1.RDa")
  )
  expect_equivalent(
    names(nltt_stats),
    c("sti", "ai", "pi", "si", "nltt_stat")
  )
})
