context("create_figure_error")

test_that("example", {

  path <- tempdir()
  #path <- path.expand("~")
  svg_filenames <- c(
    paste0(path, "/figure_error.svg"),
    paste0(path, "/figure_error_head.svg"),
    paste0(path, "/figure_error_tail.svg")
  )
  testthat::expect_false(all(file.exists(svg_filenames)))
  parameters <- wiritttea::read_collected_parameters()
  nltt_stats <- wiritttea::read_collected_nltt_stats(burn_in = 0.2)
  testthat::expect_silent(
    wiritttea::create_figure_error(
      parameters = parameters,
      nltt_stats = nltt_stats,
      svg_filenames = svg_filenames,
      cut_x = 0.05,
      verbose = FALSE
    )
  )
  testthat::expect_true(all(file.exists(svg_filenames)))
})
