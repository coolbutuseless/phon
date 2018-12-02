context("test-rhymes")

test_that("can calculate rhymes", {
  res <- rhymes('carry')
  expect_length(res, 3)
  expect_type(res, 'list')
  expect_equal(res[[1]][1], 'apothecary')


  expect_error(rhymes('carry', match_length = 1), "No valid match_length specified")
})
