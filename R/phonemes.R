

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Return phonemes for the given word
#'
#' This function returns the original phonemes as provided in \code{cmudict}.
#'
#'
#' @param word word to lookup in CMU Pronouncing Dictionary
#' @param keep_stresses keep the phoneme stresses? default: FALSE
#'
#' @return Character vector. Each entry is one variation on
#'         the pronunciation of the given word. The character vectors are the
#'         ARPABET phonetic transcription codes of the word
#'
#' @examples
#' phonemes("cellar")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phonemes <- function(word, keep_stresses = FALSE) {

  res <- unname(cmudict[names(cmudict) == word])

  if (!keep_stresses) {
    res <- remove_stresses(res)
  }

  res
}

