


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
# Function to create the groupings
# @param N number of phonemes which must match at the end of a word
create_rhyme_grouping <- function(N) {

  # Collapse the last N phonemes in every word into a string
  ends <- rphons %>% map_chr(~paste(.x[seq(N)], collapse = ' '))

  # make it a data.frame so I can unleash dplyr upon it!
  # - words: the raw words list
  # - lens : Number of phonemes in each word
  # - group: Integer representing each group of words with the same set of
  #          final N phonemes
  last_syls <- data_frame(
    words = cmu_words,
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


# Get lengths of all phons for all words
lens <- cmu_phons %>% map_int(length)

# Using the 'sans stress' phons
rphons <- map(cmu_phons_sans_stress, rev)

# Create all rhyme group assignments considering
#  - from 1 matching phonemes at the end,
#  - up to 13 phonemes at the end
cmu_rhyme_group_sans_stress <- 1:13 %>% map(create_rhyme_grouping)

# But the "1" matching phoneme is quite large
cmu_rhyme_group_sans_stress[1] <- list(NULL)




# Using the 'sans stress' phons
rphons <- map(cmu_phons, rev)

# Create all rhyme group assignments considering
#  - from 1 matching phonemes at the end,
#  - up to 13 phonemes at the end
cmu_rhyme_group <- 1:13 %>% map(create_rhyme_grouping)

# But the "1" matching phoneme is quite large
cmu_rhyme_group[1] <- list(NULL)