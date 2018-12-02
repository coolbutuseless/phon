context("test-homophones")

test_that("homophones works", {
  res <- homophones('carry')
  expect_type(res, 'character')
  expect_true(length(res) > 0)
  expect_true('carie' %in% res)
})


test_that("homophones works when word not in dictionary", {
  res <- homophones('xxxxxzzzz')
  expect_type(res, 'character')
  expect_length(res, 0)
})
