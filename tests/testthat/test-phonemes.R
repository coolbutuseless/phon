context("test-phonemes")

test_that("phonemes works", {
  res <- phonemes('carry', keep_stresses = TRUE)
  expect_type(res, 'character')
  expect_length(res, 2)
  expect_identical(res[1], "K AE1 R IY0")
  expect_identical(res[2], "K EH1 R IY0")


  res <- phonemes('carry')
  expect_type(res, 'character')
  expect_length(res, 2)
  expect_identical(res[1], "K AE R IY")
  expect_identical(res[2], "K EH R IY")

})


test_that("phonemes works when word not in dictionary", {
  res <- phonemes('xxxxzzzz')
  expect_type(res, 'character')
  expect_length(res, 0)
})
