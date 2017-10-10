context("create_figure_alignment_qualities")

test_that("works", {

  filename <- tempfile(pattern = "figure_alignment_qualities_", fileext = ".svg")
  df_alignments <- wiritttea::read_collected_alignments()
  testthat::expect_false(file.exists(filename))

  wiritttea::create_figure_alignment_qualities(
    df_alignments = df_alignments,
    filename = filename
  )
  testthat::expect_true(file.exists(filename))

})
