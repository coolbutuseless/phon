

rhymes_empty_df <- data.frame(rhyme_length = integer(0), word = character(0))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find rhymes for the given word
#'
#' To find rhymes, \code{phon} compares trailing phonemes. Words rhyme with each
#' other if they have the same phonemes at the end.
#'
#' @inheritParams homophones
#' @param min_phonemes the minimum number of matching phonemes. Default: 3
#'
#' @return data.frame of rhymes with \code{rhyme_length} giving the number of
#' trailing phonems which match the given word.
#'
#' @examples
#' rhymes("drudgery")
#'
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes <- function(word, keep_stresses = FALSE, min_phonemes = 3L) {

  phons <- phonemes(word, keep_stresses)
  rhyms <- rhymes_phonemes(phons, keep_stresses, min_phonemes)

  rhyms <- rhyms[rhyms$word != word,]
  rhyms
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find rhymes for the given phoneme strings
#'
#' To find rhymes, \code{phon} compares trailing phonemes. Words rhyme with each
#' other if they have the same phonemes at the end.
#'
#' @inheritParams homophones_phonemes
#' @param min_phonemes the minimum number of matching phonemes. Default: 3
#'
#' @return data.frame of rhymes with \code{rhyme_length} giving the number of
#' trailing phonems which match the given word.
#'
#' @examples
#' rhymes_phonemes_single("D R AH1 JH ER0 IY0")
#'
#' @import stringr
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes_phonemes_single <- function(phons, keep_stresses = FALSE, min_phonemes = 3L) {

  stopifnot(length(phons) == 1L)
  phons <- sanitize_phons(phons)
  dict  <- choose_dict(keep_stresses)

  if (!keep_stresses) {
    phons <- remove_stresses(phons)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # The rhyme search uses the phonemes string split into individiual phonemes
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  phon_bits <- stringr::str_split(phons, "\\s+")[[1]]

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # if the number of phonemes is less that the min_phonemes for a rhyme,
  # then return an empty data.frame
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (length(phon_bits) < min_phonemes) {
    return( rhymes_empty_df )
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Pre-allocate space for the results
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  res <- vector('list', length(phon_bits))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Search for each suffix.
  #   - construct a search string consisting of the last N phonemes
  #   - find words which end in with these phonemes
  #   - repeat the process, but only search within words which already matched
  #     at the smaller N phonemes
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  for (i in seq(min_phonemes, length(phon_bits))) {
    end_phons  <- paste(tail(phon_bits, i), collapse = " ")
    idxs       <- which(endsWith(dict, end_phons))
    dict       <- dict[idxs]
    if (length(dict) == 0L) { break }
    res[[i]]   <- data.frame(rhyme_length = i, word = names(dict), stringsAsFactors = FALSE)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Combine all results
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  res <- do.call('rbind', res)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # If the results is somehow empty, return a standard empty results data.frame
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (is.null(res) || nrow(res) == 0L || ncol(res) == 0) {
    return(rhymes_empty_df)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Return the sorted rhyme vectors
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  res[with(res, order(-rhyme_length, word)), ]
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname rhymes_phonemes_single
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes_phonemes <- function(phons, keep_stresses = FALSE, min_phonemes = 2L) {
  phons <- sanitize_phons(phons)


  res <- lapply(phons, rhymes_phonemes_single, keep_stresses, min_phonemes)
  res <- do.call(rbind, res)

  if (nrow(res) == 0L || ncol(res) == 0) {
    return(rhymes_empty_df)
  }

  res[with(res, order(-rhyme_length, word)), ]
}

