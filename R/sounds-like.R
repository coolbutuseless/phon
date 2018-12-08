

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonemes to the given phoneme string
#'
#' @inheritParams homophones_phonemes
#' @param phoneme_mismatches Maximum number of phonemes which can differ. Default 1
#'
#' @import utils
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sounds_like_phonemes_single <- function(phons, keep_stresses = FALSE, phoneme_mismatches = 1L) {

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # prepare phons
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  stopifnot(length(phons) == 1L)
  this_phon <- sanitize_phons(phons)
  this_phon <- stringr::str_split(this_phon, "\\s+")[[1]]

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Select dict with/without stresses
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (keep_stresses) {
    phons_dict <- cmudict
  } else {
    phons_dict <- remove_stresses(cmudict)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # precalc the max length we're going to compare
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  lpron <- length(this_phon)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Maximum number of mismatches is the length of the phonetic encoding minus 1
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (phoneme_mismatches >= lpron) {
    phoneme_mismatches <- lpron - 1
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # scan every word to see how it matches the given phonetic encoding.
  # Consider a word similar if
  #   - same number of phonemes, and
  #   - count of differences in phonemes <= phoneme_mismatches
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  cmu_phons_split <- stringr::str_split(phons_dict, "\\s")
  idxs <- seq_along(cmu_phons_split)

  idxs <- Filter(
    function(.x) {
      length(cmu_phons_split[[.x]]) == lpron &&
        sum(cmu_phons_split[[.x]] != this_phon) <= phoneme_mismatches
    },
    idxs
  )


  names(phons_dict[idxs])
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonemes to the given phoneme strings
#'
#' @inheritParams sounds_like_phonemes_single
#'
#' @import utils
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sounds_like_phonemes <- function(phons, keep_stresses = FALSE, phoneme_mismatches = 1L) {
  words <- lapply(phons, sounds_like_phonemes_single, keep_stresses, phoneme_mismatches)
  sort(unique(unlist(words, use.names = FALSE)))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words with a similar phonemes to the given word
#'
#' Similar sounding words are found by comparing words with the same number
#' of phonemes but with a number of mismatches allowed.
#'
#' @inheritParams homophones
#' @param phoneme_mismatches Maximum number of phonemes which can be different between
#'                           between words. Default: 1
#'
#'
#' @return Character vector of similar words.
#'
#' @examples
#' sounds_like("statistics", phoneme_mismatches = 5)
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sounds_like <- function(word, keep_stresses = FALSE, phoneme_mismatches = 1L) {

  if (keep_stresses) {
    phons_dict <- cmudict
  } else {
    phons_dict <- remove_stresses(cmudict)
  }

  phons <- phons_dict[names(phons_dict) == word]
  words <- sounds_like_phonemes(phons, keep_stresses, phoneme_mismatches)

  if (is.null(words)) {
    return(character(0))
  }

  # return a character vector of all matches, exluding the starting word
  setdiff(words, word)
}

