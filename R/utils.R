

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Remove stresses from phonemes
#'
#' @param x phonemes
#'
#' @return modified phonemes with stresses removed
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
remove_stresses <- function(x) {
  setNames(stringr::str_replace_all(x, "[012]", ""), names(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Sanitize phons
#'
#' ensure only a single space between individual phonemes, and that there
#' are no spaces at either end
#'
#' @param phons Vector of phoneme character strings.
#'
#' @return Sanitized phons
#'
#' @import stringr
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sanitize_phons <- function(phons) {
  stopifnot(is.character(phons))
  stopifnot(!any(is.na(phons)))

  phons <- stringr::str_replace_all(phons, "\\s+", " ")
  phons <- stringr::str_trim(phons)

  phons
}

