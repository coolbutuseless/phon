

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Number of syllables in a word
#'
#' The number of syllables in a word is the count of the number of stressed phonemes
#' in the word.
#'
#' @param word count syllables in these word
#' @param first_only If TRUE, only return the syllable count for the first pronunciation
#'                   of the word, otherwise return all syllable counts for all
#'                   pronunciations. Default: TRUE
#'
#' @return Vector of counts of syllables in words. Returns \code{NA_Integer} if word
#' is not in the CMU Pronouncing Dictionary.
#'
#' @examples
#' syllables("average")
#' syllables("antidisestablishmentarianism")
#'
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syllables <- function(word, first_only = TRUE) {


  phons <- cmudict[names(cmudict) == word]

  if (length(phons) == 0L) {
    # Word not in dictionary
    return(NA_integer_)
  }


  if (first_only) {
    # Only do the first pronunciation
    phons  <- phons[1]
  }

  stringr::str_count(phons, "[012]")
}

