context("test-rhymes")

test_that("can calculate rhymes", {
  res <- rhymes('carry')
  expect_equal(res$word[1], 'apothecary')


  res <- rhymes('carry', keep_stresses = TRUE)
  expect_equal(res$word[1], 'buccheri')


  # 'a' only has one phoneme, and will rhyme with nothing
  # given the default of min_phonemes = 2
  res <- rhymes('a', min_phonemes = 2)
  expect_equal(nrow(res), 0)


  res <- rhymes('a', min_phonemes = 1)
  expect_equal(nrow(res), 7547)


  res <- rhymes_phonemes('aa bb cc dd')

})
