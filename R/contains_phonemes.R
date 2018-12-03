

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find words which contain the given phoneme sequence
#'
#' @param phonemes a character vector of phonemes to look for
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
    warning("First argument to 'contains_phonemes()' should be a character vector of phonemes, not a list. I'm going to use the first element of the list you provided and carry on...")
    phonemes <- phonemes[[1]]
  }

  # Make sure the given phonemes match the format of cmu_phons_orig and
  # cmu_phons_orig_sans_stresses i.e. "xx xx xx xx"
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

