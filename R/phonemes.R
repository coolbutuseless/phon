

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Return phonemes for the given word
#'
#' This function returns the original phonemes as provided in \code{cmudict}.
#' The phonemes have been processed into a vector of individual phonemes rather
#' than the original form (which was a single space-separated string).
#'
#' Since words may have multiple pronunciations, this function always returns
#' a list of character vectors - one for each pronunciation of the given word.
#'
#' @param word word to lookup in CMU Pronouncing Dictionary
#' @param keep_stresses keep the phoneme stresses? default: FALSE
#'
#' @return list of character vectors. Each character vector is one variation on
#'         the pronunciation of the given word. The character vectors are the
#'         ARPABET phonetic transcription codes of the word
#'
#' @examples
#' phonemes("cellar")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phonemes <- function(word, keep_stresses = FALSE) {
  idxs   <- get_word_idxs(word)

  res <- cmu_phons[idxs]

  if (!keep_stresses) {
    res <- lapply(res, remove_stresses)
  }

  res
}

