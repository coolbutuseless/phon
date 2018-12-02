

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
cmu <- stringr::str_split(cmu_raw, "\\s+", n=2L, simplify = TRUE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Convert the first column into a list of lowercase words.
# Some words are included multiple times to indicate alternate pronunciations.
# e.g. if 'xxx' has 2 pronunciations, the first is 'xxx' and the second
# is 'xxx(1)'.
# Going to remove all the "(N)" suffixes from the words
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
words <- cmu[,1]
words[35418] <- 'DJ'
words <- stringr::str_to_lower(gsub("\\(.*?\\)", "", words))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Split the phoneme string for each word into a character vector of
# phonemes   e.g. "X  Y  Z" becomes c("X", "Y", "Z")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phons <- stringr::str_split(cmu[,2], "\\s+")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Remove stress markers
# Some syllables are suffixed with a number to indicate the stress on the syllable
# I'm just going to remove all these.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phons_sans_stress <- phons %>% map(~gsub("[012]", '', .x))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Rhyming lookups
#
# I'm going to consider "rhyming" to be the matching of multiple syllables
# at the end of each word's phonetic encoding.
#
# The more syllables which match, then the better the match.
#
# Revese the order of the phonemes for each word then construct groupings such:
#
#  - for each word that has N or more syllables
#  - assign the same number to all words which have the same last N phonemes
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
rphons <- map(phons_sans_stress, rev)
lens   <- rphons %>% map_int(length)


# Function to create the groupings
# @param N number of phonemes which must match at the end of a word
create_last_syls_grouping <- function(N) {

  # Collapse the last N phonemes in every word into a string
  ends <- rphons %>% map_chr(~paste(.x[seq(N)], collapse = ' '))

  # make it a data.frame so I can unleash dplyr upon it!
  # - words: the raw words list
  # - lens : Number of phonemes in each word
  # - group: Integer representing each group of words with the same set of
  #          final N phonemes
  last_syls <- data_frame(
    words,
    lens,
    group = as.integer(as.factor(ends))
  )

  # Only going to label groups which have a least 2 memebers.
  group_has_friends <- last_syls %>%
    filter(lens >= N) %>%
    group_by(group) %>%
    tally() %>%
    filter(n > 1) %>%
    arrange(desc(n)) %>%
    pull(group)

  # Groups which have fewer than 2 members, are renumbered to group = 0
  # so that they can be filtered later
  last_syls <- last_syls %>% mutate(
    group = ifelse(group %in% group_has_friends, group, 0L),
    group = as.integer(as.factor(group)) - 1L # compact the group numbering
  )

  # return the integer vector of group assignment (this elements of this vector
  # align with the 'words' data)
  last_syls$group
}

# Create all group assignments considering from 2 matching phonemes at the end,
# up to 12 phonemes at the end
last_syls_group <- 1:13 %>% map(create_last_syls_grouping)

last_syls_group[1] <- list(NULL)





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Homophones have the exact same pronunciation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cmu2 <- cmu[, 2]
cmu2 <- gsub("[012]", "", cmu2)

homs <- data_frame(
  words,
  idx  = as.integer(as.factor(cmu2))
)


has_homs <- homs %>%
  group_by(idx) %>%
  tally() %>%
  filter(n > 1) %>%
  arrange(desc(n)) %>%
  pull(idx)


homs <- homs %>% mutate(
  idx = ifelse(idx %in% has_homs, idx, 0L),
  idx = as.integer(as.factor(idx)) - 1L
)

hom_group <- homs$idx




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# collapsed phons into a single string per word
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
phons_orig <- cmu[,2]


phons_orig_sans_stress <- gsub("[012]", "", phons_orig)




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Syllables
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syls <- phons %>% purrr::map_int(~sum(grepl("[012]", .x)))


cmu_words                  <- words
cmu_syls                   <- syls
cmu_phons                  <- phons
cmu_phons_orig             <- phons_orig
cmu_phons_orig_sans_stress <- phons_orig_sans_stress
cmu_last_syls_group        <- last_syls_group
cmu_hom_group              <- hom_group

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Save all the internal data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
usethis::use_data(cmu_words,
                  cmu_last_syls_group,
                  cmu_hom_group,
                  cmu_syls,
                  cmu_phons,
                  cmu_phons_orig,
                  cmu_phons_orig_sans_stress,
                  internal = TRUE, overwrite = TRUE, compress = 'xz')





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The Master list of all unique phons
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# all_phons <- flatten_chr(phons) %>% sort %>% unique()
# all_phons


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Phon_lookup is small enough to fit in a 'raw' if needed
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# phon_lookup <- setNames(seq_along(all_phons), all_phons)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Recode all the phons to their index
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# phons <- map(phons, ~(unname(phon_lookup[.x])))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name the phons list
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# names(phons) <- words










