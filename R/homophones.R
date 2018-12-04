

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
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
homophones <- function(word, keep_stresses = FALSE) {
  if (keep_stresses) {
    phons_dict <- cmudict
  } else {
    phons_dict <- remove_stresses(cmudict)
  }

  phons <- phons_dict[names(cmudict) == word]

  idxs <- lapply(phons, function(x) { which(phons_dict == x) })
  idxs <- sort(unique(unlist(idxs)))

  setdiff(names(cmudict[idxs]), word)
}

