

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find rhymes for the given word
#'
#' To find rhymes, \code{phon} compares trailing phonemes i.e. if the phonemes at the end of a
#' word in the dictionary match those at the end of the given word, then they rhyme.
#'
#' The rhymes are returned in multiple vectors:
#' \itemize{
#' \item{Words with the most matching trailing phonemes are returned first.}
#' \item{Subsequent vectors have fewer matching trailing phonemes.}
#' \item{Words in earlier vectors are repeated in later vectors.}
#' }
#'
#' @param word word for which to find rhymes
#' @param keep_stresses keep the phoneme stresses? default: FALSE
#' @param min_phonemes the minimum number of matching phonemes. Default: 2L
#'
#' @return list of rhymes grouped by number of mathching trailing phonemes with
#' the supplied word
#'
#' @examples
#' rhymes("drudgery")
#'
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes <- function(word, keep_stresses = FALSE, min_phonemes = 2L) {

  # Ensure user can't set impossible value
  min_phonemes <- max(c(min_phonemes, 1L))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Choose the phons dictionary. With or without stresses?
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (keep_stresses) {
    phons_dict <- cmudict
  } else {
    phons_dict <- remove_stresses(cmudict)
  }


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Find the phonemes for the given word, and create some space for the results
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  phons   <- phons_dict[names(cmudict) == word]
  phons   <- strsplit(phons, "\\s")
  lens    <- vapply(phons, length, integer(1L))
  max_len <- max(lens)
  res     <- vector('list', max_len)


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # For each possible pronunciation, find the rhymes and merge into
  # a single rhyme list
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  for (this_phons in phons) {
    if (length(this_phons) < min_phonemes) { next }
    for (i in seq(length(this_phons), min_phonemes, -1L)) {
      end_phons <- paste0(paste(tail(this_phons, i), collapse = " "), "$")

      # idxs_with_matching_end_phons <- which(stringr::str_detect(phons_dict, end_phons))
      idxs_with_matching_end_phons <- stringr::str_which(phons_dict, end_phons)

      li <- max_len + 1L - i
      res[[li]] <- c(res[[li]], setdiff(names(cmudict)[idxs_with_matching_end_phons], word))
    }
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Only keep non-empty rhyme vectors
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  res <- Filter(function(x) {length(x) > 0L}, res)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Return the sorted rhyme vectors
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  lapply(res, sort)
}



















