

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words which contain the given phoneme sequence
#'
#' @param phonemes the character vector of phonemes to look for
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

  # Be careful: phon::phonemes() returns a list, and user will probably try
  # calling this with that output, rather than with an element of that list.
  # So just peel off the first element in the list and use that.
  if (is.list(phonemes)) {
    warning("'phonemes' should be a character vector, not a list. Using only first element of list.")
    phonemes <- phonemes[[1]]
  }

  phonemes <- paste(phonemes, collapse = " ")
  phonemes <- gsub('\\s+', ' ', phonemes)
  phonemes <- trimws(phonemes)

  if (keep_stresses) {
    idxs <- grep(phonemes, cmu_phons_orig)
  } else {
    phonemes <- remove_stresses(phonemes)
    idxs     <- grep(phonemes, cmu_phons_orig_sans_stress)
  }

  cmu_words[idxs]
}

