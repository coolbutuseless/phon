

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Get a copy of the cmudict
#'
#' The cmudict used internal to the package is pre-processed for faster lookups
#' and to save memory.
#'
#' This function creates a named vector of phonemes for use external to the
#' package
#'
#' @return named vector of phonemes
#'
#' @importFrom stats setNames
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
get_cmudict <- function() {
  setNames(cmu_phons_orig, cmu_words)
}