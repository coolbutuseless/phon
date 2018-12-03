

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Homophones. Same pronunciation - without stresses
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

homs <- data_frame(
  words = cmu_words,
  idx   = as.integer(as.factor(cmu_phons_orig_sans_stress))
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

cmu_homophone_group_sans_stress <- homs$idx

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Homophones. Same pronunciation - with stresses
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

homs <- data_frame(
  words = cmu_words,
  idx   = as.integer(as.factor(cmu_phons_orig))
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

cmu_homophone_group <- homs$idx