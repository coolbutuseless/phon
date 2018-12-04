

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonetic makeup to the given phonetic encoding
#'
#' @param this_phon character vector of phonetic encoding
#' @param phoneme_mismatches Maximum number of phonemes which can differ. Default 1
#'
#' @import utils
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sounds_like_phonemes <- function(this_phon, phoneme_mismatches = 1L) {
  lpron <- length(this_phon)

  # Maximum number of mismatches is the length of the phonetic encoding minus 1
  if (phoneme_mismatches >= lpron) {
    phoneme_mismatches <- lpron - 1
  }

  # scan every word to see how it matches the given phonetic encoding
  cmu_phons_split <- stringr::str_split(cmudict, "\\s")
  idxs <- seq_along(cmu_phons_split)

  idxs <- Filter(
    function(.x) {
      length(cmu_phons_split[[.x]]) == lpron &&
        sum(cmu_phons_split[[.x]] != this_phon) <= phoneme_mismatches
    },
    idxs
  )

  names(cmudict[idxs])
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonetic makeup
#'
#' Similar sounding words are found by comparing words with the same number
#' of phonemes but with a number of mismatches allowed.
#'
#' @param word Find words similar to this
#' @param phoneme_mismatches Maximum number of phonemes which can be different between
#'                           between words. Default: 1
#'
#'
#' @return character vector of similar words
#'
#' @examples
#' sounds_like("statistics", phoneme_mismatches = 5)
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sounds_like <- function(word, phoneme_mismatches = 1L) {
  this_phons <- stringr::str_split(cmudict[names(cmudict) == word], "\\s")

  similar_words <- lapply(this_phons, sounds_like_phonemes, phoneme_mismatches)
  similar_words <- unique(sort(unlist(similar_words)))

  if (is.null(similar_words)) {
    return(character(0))
  }

  # return a list of all matches, exluding the starting word
  setdiff(similar_words, word)
}

