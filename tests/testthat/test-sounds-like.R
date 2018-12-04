context("test-similar")

test_that("sounds_like works", {
  res <- sounds_like("statistics", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)


  res <- sounds_like("statistics", phoneme_mismatches = 50)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)

})


test_that("sounds_like works when word not in dictionary", {
  res <- sounds_like("zzzzxxxx", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_length(res, 0)
})
