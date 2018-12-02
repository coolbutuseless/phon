

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find rhymes for a given trailing phoneme match length
#'
#' Look up the word in the 'last_syls_group' data
#'
#' @param word word for which to find rhymes
#' @param match_length how good a rhyme? the higher the number the more
#'                     trailing phoneme matches between the word and any
#'                     selected rhyming word. Use a range. Default: 2:13.
#'                     Min = 2, Max = 13
#'
#' @return character vector of words (excluding the given word). returns
#' \code{character(0)} if no rhymes found.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes_core <- function(match_length, word) {
  word   <- tolower(word)
  idxs   <- which(cmu_words == word)
  groups <- unique(cmu_last_syls_group[[match_length]][idxs])
  groups <- groups[groups != 0L]
  idxs   <- which(cmu_last_syls_group[[match_length]] %in% groups)

  setdiff(cmu_words[idxs], word)
}


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
#' \item{The names of the list are the number of trailing phonemes which match.}
#' \item{If there are no rhymes of the given match length, then no space in the
#'       returned list is reserved for this empty vector.}
#' }
#'
#'
#' @inheritParams rhymes_core
#'
#' @return list of rhymes separated by rhyme intensity level
#'
#' @examples
#' rhymes("drudgery")
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rhymes <- function(word, match_length = 2:13) {
  match_length <- as.integer(sort(match_length, decreasing = TRUE))
  match_length <- match_length[match_length >= 2L & match_length <= 13L]
  match_length <- match_length[!is.na(match_length)]

  if (length(match_length) == 0L) {
    stop("No valid match_length specified")
  }

  res <- lapply(match_length, rhymes_core, word)
  res <- setNames(res, match_length)

  Filter(function(x) {length(x) > 0}, res)
}

