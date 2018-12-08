

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Calculate number of syllables in each phoneme string.
#'
#' The number of syllables is the count of the number of stressed phonemes
#' in the word.
#'
#' @param phons Vector of phoneme strings e.g. c("K AE1 R IY0", "K EH1 R IY0")
#'
#' @return Integer vector of counts of syllables in each phoneme string.
#'
#' @examples
#' syllables_phonemes(phonemes("average", keep_stresses = TRUE))
#' syllables_phonemes(c("G R EY1 T", "F AE0 N T AE1 S T IH0 K"))
#'
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syllables_phonemes <- function(phons) {
  if (length(phons) == 0L) {
    NA_integer_
  } else {
    stringr::str_count(phons, "[012]")
  }
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Calculate number of syllables in a word.
#'
#' The number of syllables in a word is the count of the number of stressed phonemes
#' in the word.
#'
#' @param word single word
#' @param all_pronunciations If TRUE, return the syllable counts for all pronunciations,
#' otherwise only return syllable count for the first pronunciation.
#' Default: FALSE
#'
#' @return Integer vector of counts of syllables in word. Returns \code{NA_Integer} if word
#' is not in the CMU Pronouncing Dictionary.
#'
#' @examples
#' syllables("average")
#' syllables("antidisestablishmentarianism")
#'
#' @importFrom stats setNames
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syllables <- function(word, all_pronunciations = FALSE) {
  stopifnot(length(word) == 1L)

  phons <- phonemes(word, keep_stresses = TRUE)
  syls  <- syllables_phonemes(phons)

  if (all_pronunciations) {
    syls
  } else {
    syls[1]
  }
}
