

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Can't include 2 versions of the dictionary in the package as data size would
# be greater than 1MB.
# Calculating cmudict-without-stresses on-the-fly is a real big time penalty
# in using the package.
#
# Solution:
#  - Create a copy of 'cmudict' without the stresses.
#  - Put it an environment.
#  - Put the environemnt in an 'option' so we can access it from anywhere.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.onLoad <- function(...) { # nocov start
  ne                      <- new.env(parent = emptyenv())
  ne$cmudict_san_stresses <- setNames(stringr::str_replace_all(phon::cmudict, "[012]", ""), names(phon::cmudict))
  options(phon_env = ne)
} # nocov end