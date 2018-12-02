context("test-syllables")

test_that("syllables works", {
  expect_identical(syllables("average"), 3L)
  expect_identical(syllables("antidisestablishmentarianism"), 12L)
})

test_that("syllables works when word not in dictionary", {
  expect_identical(syllables("xxxxzzz"), NA_integer_)
})
