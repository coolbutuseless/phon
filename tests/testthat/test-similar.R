context("test-similar")

test_that("sounds_similar works", {
  res <- sounds_similar("statistics", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)


  res <- sounds_similar("statistics", phoneme_mismatches = 50)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)

})


test_that("sounds_similar works when word not in dictionary", {
  res <- sounds_similar("zzzzxxxx", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_length(res, 0)
})
