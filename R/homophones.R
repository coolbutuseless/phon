

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find all homophones of the given word
#'
#' Homophones are words with the same pronunciation but different spelling.
#'
#' This function finds the phonemes (without stresses) for the given word, and
#' finds all other words with the same phonemes.
#'
#' @param word find homophones for this word
#'
#' @return character vector of homophones.
#'
#' @examples
#' homophones("steak")
#' homophones("carry")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
homophones <- function(word) {
  word   <- tolower(word)
  idxs   <- which(cmu_words == word)
  groups <- unique(cmu_hom_group[idxs])
  groups <- groups[groups != 0]
  idxs   <- which(cmu_hom_group %in% groups)

  setdiff(cmu_words[idxs], word)
}

