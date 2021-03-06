context("read_collected_esses")

test_that("read_collected_esses use", {
  df <- read_collected_esses()
  expected_names <- c("filename", "sti", "ai", "pi", "posterior",
    "likelihood", "prior", "treeLikelihood", "TreeHeight", "BirthDeath",
    "birthRate2", "relativeDeathRate2")
  expect_true(all(names(df) == expected_names))
  expect_true(is.factor(df$filename))
  expect_true(is.factor(df$sti))
  expect_true(is.factor(df$ai))
  expect_true(is.factor(df$pi))
})
