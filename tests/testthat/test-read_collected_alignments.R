context("read_collected_alignments")

test_that("example", {

    csv_filename <- wiritttea::find_path("read_collected_alignments.csv")
    df <- read_collected_alignments(csv_filename)
    testthat::expect_true(is.factor(df$filename))
    testthat::expect_true(nrow(df) > 0)
})
