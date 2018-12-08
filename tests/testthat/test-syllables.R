context("test-syllables")

test_that("syllables works", {
  expect_identical(unname(syllables("average")), 3L)
  expect_identical(unname(syllables("antidisestablishmentarianism")), 12L)
  expect_identical(unname(syllables("carry", all_pronunciations = TRUE)), c(2L, 2L))
})

test_that("syllables works when word not in dictionary", {
  res <- syllables("xxxxzzz")
  expect_identical(unname(res), NA_integer_)
})
