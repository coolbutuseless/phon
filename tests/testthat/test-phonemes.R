context("test-phonemes")

test_that("phonemes works", {
  res <- phonemes('carry', keep_stresses = TRUE)
  expect_type(res, 'list')
  expect_length(res, 2)
  expect_type(res[[1]], 'character')
  expect_identical(res[[1]], c("K", "AE1", "R", "IY0"))
  expect_identical(res[[2]], c("K", "EH1", "R", "IY0"))


  res <- phonemes('carry')
  expect_type(res, 'list')
  expect_length(res, 2)
  expect_type(res[[1]], 'character')
  expect_identical(res[[1]], c("K", "AE", "R", "IY"))
  expect_identical(res[[2]], c("K", "EH", "R", "IY"))

})


test_that("phonemes works when word not in dictionary", {
  res <- phonemes('xxxxzzzz')
  expect_type(res, 'list')
  expect_length(res, 0)
})
