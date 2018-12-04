context("test-rhymes")

test_that("can calculate rhymes", {
  res <- rhymes('carry')
  expect_length(res, 3)
  expect_type(res, 'list')
  expect_equal(res[[1]][1], 'apothecary')


  res <- rhymes('carry', keep_stresses = TRUE)
  expect_length(res, 3)
  expect_type(res, 'list')
  expect_equal(res[[1]][1], 'buccheri')


  # 'a' only has one phoneme, and will rhyme with nothing
  # given the default of min_phonemes = 2
  res <- rhymes('a', min_phonemes = 2)
  expect_length(res, 0)


  res <- rhymes('a', min_phonemes = 1)
  expect_length(res, 1)
})
