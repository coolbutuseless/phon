

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
  dict  <- choose_dict(keep_stresses)

  if (!keep_stresses) {
    phons <- remove_stresses(phons)
  }

  idxs <- stringr::str_which(dict, phons)

  names(dict[idxs])
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

    dict  <- choose_dict(keep_stresses)
    phons <- dict[names(dict) == word]
    words <- contains_pronunciation_phonemes(phons, keep_stresses)
    setdiff(words, word)
}

