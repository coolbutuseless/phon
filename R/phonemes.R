

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

  dict  <- choose_dict(keep_stresses)
  phons <- unname(dict[names(dict) == word])

  phons
}

