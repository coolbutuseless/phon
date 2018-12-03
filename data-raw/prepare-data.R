

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
})


# This package uses the CMU Pronouncing Dictionary.
# See:
#   http://www.speech.cs.cmu.edu/cgi-bin/cmudict
#   http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/


# In order to make look-ups for rhymes and homophones faster, I'm going to
# do a lot of preprocessing of the data


# Also to keep memory footprint low, I'm recoding the given data into
# alternate structures and doing manual bookkeepping
# E.g. the complete list of words is only saved once. All other vectors and lists
# are unnamed, but in the same order as the words list.  This saves memory, but
# increases the amount of work which must be done to lookup phonemes


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
# collapsed phons into a single string per word
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_phons_orig             <- cmu_mat[,2]
cmu_phons_orig_sans_stress <- gsub("[012]", "", cmu_phons_orig)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Split the phoneme string for each word into a character vector of
# phonemes   e.g. "X  Y  Z" becomes c("X", "Y", "Z")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_phons             <- stringr::str_split(cmu_phons_orig, "\\s+")
cmu_phons_sans_stress <- stringr::str_split(cmu_phons_orig_sans_stress, "\\s+")


source(here::here("data-raw", "create-data-homophones.R"))

source(here::here("data-raw", "create-data-rhymes.R"))




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Syllables
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu_syls <- stringr::str_count(cmu_phons_orig, "[012]")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save all the internal data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
usethis::use_data(cmu_words,
                  cmu_phons_orig     , cmu_phons_orig_sans_stress,
                  cmu_phons          , cmu_phons_sans_stress,
                  cmu_rhyme_group    , cmu_rhyme_group_sans_stress,
                  cmu_homophone_group, cmu_homophone_group_sans_stress,
                  cmu_syls,

                  internal = TRUE, overwrite = TRUE, compress = 'xz')


file.size(here::here("R/sysdata.rda"))





