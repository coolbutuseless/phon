

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words which contain the given phoneme sequence
#'
#' @param phonemes a character string of phonemes to look for
#' @param keep_stresses keep the stresses attached to each phonmeme? default: FALSE
#'        If FALSE, more likely to find matches, but may be less accurate.
#'
#' @return Character vector of words which contain the given phonemes
#'
#' @examples
#' # Find all words which contain the sound of "through" when spoken
#' phons <- phonemes("through")[[1]]
#' contains_phonemes(phons)
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
contains_phonemes <- function(phonemes, keep_stresses = FALSE) {

  stopifnot(length(phonemes) == 1L)

  # Make sure the given phonemes match the format i.e. "xx xx xx xx"
  phonemes <- gsub('\\s+', ' ', phonemes)
  phonemes <- trimws(phonemes)

  if (keep_stresses) {
    idxs <- stringr::str_which(cmudict, phonemes)
  } else {
    phonemes <- remove_stresses(phonemes)
    idxs     <- stringr::str_which(remove_stresses(cmudict), phonemes)
  }

  names(cmudict[idxs])
}

