

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Export the phonemes data as a list
#'
#' The actual \code{cmudict} data is stored within \code{phon} in a
#' number of pre-processed forms. This reduces overall memory footprint,
#' and enables faster lookups of information about each word.
#'
#' \code{create_cmudict_as_list()} creates a more manageable representation of the
#' \code{cmudict} for external use.
#'
#' @return Named list of phoneme vectors (one for each word in the dictionary).
#'
#' @examples
#' create_cmudict_as_list()
#'
#' @import purrr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
create_cmudict_as_list <- function() {
  purrr::set_names(cmu_phons, cmu_words)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Export the phonemes data as a data.frame
#'
#' The actual \code{cmudict} data is stored within \code{phon} in a
#' number of pre-processed forms. This reduces overall memory footprint,
#' and enables faster lookups of information about each word.
#'
#' \code{create_cmudict_as_data_frame()} creates a more manageable representation of the
#' \code{cmudict} for external use.
#'
#' @return phonemes data as a data.frame of words and phonemes. The phonemes
#' for each word are collapsed into a single string, and included in both
#' the original format, along with a version with the stress indicators removed.
#'
#' @examples
#' create_cmudict_as_data_frame()
#'
#' @import dplyr
#' @import purrr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
create_cmudict_as_data_frame <- function() {
  dplyr::data_frame(
    word                   = cmu_words,
    phonemes               = cmu_phons_orig,
    phonemes_sans_stresses = cmu_phons_orig_sans_stress,
    syllables              = cmu_syls
  )
}

