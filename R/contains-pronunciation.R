

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words which contain the given phoneme character strings
#'
#' @inheritParams homophones_phonemes
#'
#' @return Character vector of words which contain the given phonemes
#'
#' @examples
#' # Find all words which contain the sound of "through" when spoken
#' phons <- phonemes("through")
#' contains_pronunciation_phonemes(phons)
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
contains_pronunciation_phonemes <- function(phons, keep_stresses = FALSE) {

  phons <- sanitize_phons(phons)

  if (keep_stresses) {
    phons_dict <- cmudict
  } else {
    phons_dict <- remove_stresses(cmudict)
    phons      <- remove_stresses(phons)
  }

  idxs <- stringr::str_which(phons_dict, phons)

  names(phons_dict[idxs])
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words which contain pronunciation of the given word
#'
#' @inheritParams homophones
#'
#' @return Character vector of words which contain the pronunciation of the
#'         given word.
#'
#' @examples
#' # Find all words which contain the sound of "through" when spoken
#' contains_pronunciation('through')
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
contains_pronunciation <- function(word, keep_stresses = FALSE) {
    phons <- cmudict[names(cmudict) == word]
    words <- contains_pronunciation_phonemes(phons, keep_stresses)
    setdiff(words, word)
}

