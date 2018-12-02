context("test-export")

test_that("export cmudict as list works", {
  res <- create_cmudict_as_list()
  expect_type(res, 'list')
  expect_type(names(res), 'character')
})

test_that("export cmudict as data.frame works", {
  res <- create_cmudict_as_data_frame()
  expect_true(is.data.frame(res))
  expect_true(all(c('word', 'phonemes') %in% colnames(res)))
})
