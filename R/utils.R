

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Internal helper function to lookup the indices at which this word occurs
#'
#' Words may occur multiple time in the dictionary because of multiple
#' pronunciations
#'
#' @param word find all idxs of this word
#'
#' @return integer vector of indices
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_word_idxs <- function(word) {
  stopifnot(is.character(word))
  stopifnot(length(word) == 1L)

  word <- tolower(word)
  idxs <- which(cmu_words == word)

  idxs
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Remove stresses from phonemes
#'
#' @param x phonemes
#'
#' @return modified phonemes with stresses removed
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
remove_stresses <- function(x) {
  gsub("[012]", "", x)
}
