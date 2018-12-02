

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Number of syllables in a word
#'
#' The number of syllables in a word is the count of the number of stressed phonemes
#' in the word.
#'
#' @param word count syllables in these word
#'
#' @return Vector of counts of syllables in words. Returns \code{NA_Integer} if word
#' is not in the CMU Pronouncing Dictionary.
#'
#' @examples
#' syllables("average")
#' syllables("antidisestablishmentarianism")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syllables <- function(word) {
  word <- tolower(word)
  idxs <- which(cmu_words == word)

  if (length(idxs) == 0L) {
    # Word not in dictionary
    return(NA_integer_)
  }

  # Only do the first pronunciation
  idx  <- idxs[1]

  cmu_syls[idx]
}

