

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find all homophones of the given word
#'
#' Homophones are words with the same pronunciation but different spelling.
#'
#' This function finds the phonemes (without stresses) for the given word, and
#' finds all other words with the same phonemes.
#'
#' @param word find homophones for this word
#' @param keep_stresses keep the stresses attached to each phonmeme? Default: FALSE
#'        If FALSE, more likely to find homophones, but emphasis may be different.
#'
#' @return character vector of homophones.
#'
#' @examples
#' homophones("steak")
#' homophones("carry")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
homophones <- function(word, keep_stresses = FALSE) {
  idxs   <- get_word_idxs(word)

  if (keep_stresses) {
    homophone_group <- cmu_homophone_group
  } else {
    homophone_group <- cmu_homophone_group_sans_stress
  }

  groups <- unique(homophone_group[idxs])
  groups <- groups[groups != 0]
  idxs   <- which(homophone_group %in% groups)

  setdiff(cmu_words[idxs], word)
}

