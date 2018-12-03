context("test-contains")

test_that("contains_phonemes works", {
  phons <- phonemes("through")[[1]]
  res <- contains_phonemes(phons)
  expect_type(res, 'character')
  expect_true('throughout' %in% res)


  phons <- phonemes("through")[[1]]
  res <- contains_phonemes(phons, keep_stresses = TRUE)
  expect_type(res, 'character')
  expect_true('throughput' %in% res)

  # Test func is forgiving enough to accept a list
  phons <- phonemes("through")
  suppressWarnings({
    res <- contains_phonemes(phons, keep_stresses = TRUE)
  })
  expect_type(res, 'character')
  expect_true('throughput' %in% res)
})
