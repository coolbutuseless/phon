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



  expect_error(rhymes('carry', match_length = 1), "No valid match_length specified")
})
