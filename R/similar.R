

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonetic makeup to the given phonetic encoding
#'
#' @param this_phon character vector of phonetic encoding
#' @param phoneme_mismatches Maximum number of phonemes which can differ. Default 1
#'
#' @import utils
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
similar_core <- function(this_phon, phoneme_mismatches = 1L) {
  lpron <- length(this_phon)
  tpron <- utils::tail(this_phon, 1L)

  # Maximum number of mismatches is the length of the phonetic encoding minus 1
  if (phoneme_mismatches >= lpron) {
    phoneme_mismatches <- lpron - 1
  }

  # scan every word to see how it matches the given phonetic encoding
  idxs <- seq_along(cmu_phons) %>%
    purrr::keep(~length(cmu_phons[[.x]]) == lpron && sum(cmu_phons[[.x]] != this_phon) <= phoneme_mismatches)

  cmu_words[idxs]
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonetic makeup
#'
#' Similar sounding words are found by comparing words with the same number
#' of phonemes but with a number of mismatches allowed.
#'
#' @param word Find words similar to this
#' @param phoneme_mismatches Number of phonemes which can be different between
#'                           between words. Default 1
#'
#'
#' @return character vector of similar words
#'
#' @examples
#' similar("statistics", phoneme_mismatches = 5)
#'
#' @import dplyr
#' @import purrr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
similar <- function(word, phoneme_mismatches = 1L) {
  word       <- tolower(word)
  this_phons <- cmu_phons[cmu_words == word]

  similar_words <- this_phons %>%
    purrr::map(~similar_core(.x, phoneme_mismatches)) %>%
    flatten_chr() %>%
    sort() %>%
    unique()


  # return a list of all matches, exluding the starting word
  setdiff(similar_words, word)
}

