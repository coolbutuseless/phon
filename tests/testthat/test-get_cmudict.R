context("test-get_cmudict")

test_that("get_cmudict works", {
  cmudict <- get_cmudict()
  expect_type(cmudict, "character")
  expect_true("carry" %in% names(cmudict))
})
