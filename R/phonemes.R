

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Return phonemes for the given word.
#'
#' @inheritParams homophones
#'
#' @return Vector of phoneme strings. Each string is one variation on
#'         the pronunciation of the given word, represented as the
#'         ARPABET phonetic transcription.
#'
#' @examples
#' phonemes("cellar")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phonemes <- function(word, keep_stresses = FALSE) {

  res <- unname(cmudict[names(cmudict) == word])

  if (keep_stresses) {
    res
  } else {
    remove_stresses(res)
  }
}

