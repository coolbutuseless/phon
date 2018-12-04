


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
  stringr::str_replace_all(x, "[012]", "")
}
