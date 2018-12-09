

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
})


# This package uses the CMU Pronouncing Dictionary.
# See:
#   http://www.speech.cs.cmu.edu/cgi-bin/cmudict
#   http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Raw cmu dictionary
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_raw <- readLines(here::here("data-raw", "cmudict-0.7b.txt"), encoding = 'UTF-8')


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Remove the cruft at the top of the file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_raw <- cmu_raw[-(1:56)]


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# parse into usable R structure - a matrix of characters
#  - column 1: the words
#  - column 2: string representing the ARPABET phonetic codes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_mat <- stringr::str_split(cmu_raw, "\\s+", n=2L, simplify = TRUE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Convert the first column into a list of lowercase words.
# Some words are included multiple times to indicate alternate pronunciations.
# e.g. if 'xxx' has 2 pronunciations, the first is 'xxx' and the second
# is 'xxx(1)'.
# Going to remove all the "(N)" suffixes from the words
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_words <- cmu_mat[,1]
cmu_words[35418] <- 'DJ'
cmu_words <- stringr::str_to_lower(gsub("\\(.*?\\)", "", cmu_words))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A single string oh phonemes per word
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_phons_orig <- cmu_mat[,2]


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Internal data representation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmudict <- setNames(cmu_phons_orig, cmu_words)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save all the internal data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
usethis::use_data(cmudict, internal = FALSE, overwrite = TRUE, compress = 'xz')


file.size(here::here("data/cmudict.rda"))



