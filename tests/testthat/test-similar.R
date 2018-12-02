context("test-similar")

test_that("similar works", {
  res <- similar("statistics", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)


  res <- similar("statistics", phoneme_mismatches = 50)
  expect_type(res, 'character')
  expect_true('stochastics' %in% res)

})


test_that("similar works when word not in dictionary", {
  res <- similar("zzzzxxxx", phoneme_mismatches = 5)
  expect_type(res, 'character')
  expect_length(res, 0)
})
