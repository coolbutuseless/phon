
<!-- README.md is generated from README.Rmd. Please edit that file -->

# phon <img src="man/figures/logo.png" align="right" height=230/>

[![Travis build
status](https://travis-ci.org/coolbutuseless/phon.svg?branch=master)](https://travis-ci.org/coolbutuseless/phon)
[![codecov](https://codecov.io/gh/coolbutuseless/phon/branch/master/graph/badge.svg)](https://codecov.io/gh/coolbutuseless/phon)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/coolbutuseless/phon?branch=master&svg=true)](https://ci.appveyor.com/project/coolbutuseless/phon)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

The goal of `phon` is to make available the CMU Pronouncing Dictionary
([**cmudict**](http://www.speech.cs.cmu.edu/cgi-bin/cmudict)) in an R
friendly format, and to collect some tools which use the pronunciation
information.

The CMU Pronouncing Dictionary includes pronunciations for 130,000
words. By matching the phonemes between words, `phon` provides

  - `phonemes('threw')` - Returns the phonemes for the pronunciation of
    “threw”.
  - `homophones('steak')` - Returns words which are homophones of
    “steak”.
  - `rhymes('carry')` - Returns words which rhyme with “carry”.
  - `sounds_like('greater')` - Returns words with a similar sound to
    “greater” by limiting the mismatches in phonemes the other word
    can have.
  - `contains_pronunciation('threw')` Returns words which contain the
    the pronunciation of ‘threw’ within their pronunciation
  - `syllables("useless")` Returns the count of syllables in “useless”.

This is a companion package to the [syn](http://syn.njtierney.com/)
package. `syn` finds related words based upon meanings, while `phon`
finds related words based upon pronunciation.

## Installation

You can install `phon` from github with:

``` r
devtools::install_github("coolbutuseless/phon")
```

## Phonemes

Phonemes are the sounds which make up a word.

The phonetic encoding in `phon` come from the CMU Pronouncing Dictionary
([**cmudict**](http://www.speech.cs.cmu.edu/cgi-bin/cmudict)) which
encodes words using [ARPABET](https://en.wikipedia.org/wiki/ARPABET).

``` r
phon::phonemes("cellar")
#> [1] "S EH L ER"
```

Since some words have mutliple pronunciations, the results of
`phon::phonemes()` can be a vector with more than 1 element,
e.g. *carry* has two slightly different pronunciations.

``` r
phon::phonemes("carry")
#> [1] "K AE R IY" "K EH R IY"
```

ARPABET phonetic encoding includes stress markers as suffixes to vowel
phonemes. The markers are:

0.  No stress
1.  Primary stress
2.  Secondary stress

You can ask for phonemes without the stress markers, e.g.

``` r
phon::phonemes("fantastic")
#> [1] "F AE N T AE S T IH K"

phon::phonemes("fantastic", keep_stresses = TRUE)
#> [1] "F AE0 N T AE1 S T IH0 K"
```

## Syllables

The number of syllables in a word is obtained by counting of the number
of phonemes with stress markers.

``` r
phon::syllables("average")
#> [1] 3

phon::syllables("antidisestablishmentarianism")
#> [1] 12
```

## Matching Phonemes within Words

`phon` allows you to search for the sound of one word within another.

In the following example, `phon::contains_pronunciation_phonemes()`
finds all the words that include the pronunciation of *“through”* within
their pronunciation.

``` r
phon::contains_pronunciation('through')
#>  [1] "bathroom"      "bathrooms"     "breakthrough"  "breakthroughs"
#>  [5] "drive-thru"    "drive-thrus"   "overthrew"     "threw"        
#>  [9] "throop"        "throughout"    "throughput"    "throughs"     
#> [13] "throughway"    "thru"          "thruway"
```

Use the `keep_stresses` argument to match with/without the stresses
included (default is to ignore the stresses).

## Homophones

Homophones are words with the same pronunciation but different spelling.

``` r
phon::homophones("steak")
#> [1] "stake"

phon::homophones("carry")
#>  [1] "carey"  "carie"  "carrey" "carrie" "cary"   "kairey" "kari"  
#>  [8] "karry"  "kary"   "kerrey" "kerri"  "kerry"
```

## Rhymes

To find rhymes, `phon` compares trailing phonemes. If the phonemes at
the end of a word in the dictionary match those at the end of the given
word, then they rhyme.

The rhymes are returned in multiple vectors:

  - Words with the most matching trailing phonemes are returned first.
  - Subsequent vectors have fewer matching trailing phonemes.

<!-- end list -->

``` r
phon::rhymes("drudgery", min_phonemes = 2)
```

    rhyme_length         word
                3  challengery
                3      forgery
                3      gingery
                3       injury
                3      margery
                3     marjorie
                3      marjory
                3    menagerie
                3 neurosurgery
                3      perjury
                3      surgery
                2        acary
                2    accessory
                2       adoree
                2     adultery
                2     advisory
                2   alimentary
                2   alphandery
                2       ambery
                2        amery
    ... [results trimmed]

In the above example:

  - The phonemes for “drudgery” are “D R AH1 JH ER0 IY0”
  - Where `rhyme_length == 3`, the words match the *-gery* sound, i.e
    the last 3 phonemes.
  - Where `rhyme_length == 2`, the words only match the *-ery* sound,
    i.e. the last 2 phonemes.

## Similar sounding words

Similar sounding words are found by comparing words with the same number
of phonemes but with a number of mismatches allowed.

``` r
phon::sounds_like("statistics", phoneme_mismatches = 5)
#>  [1] "anaesthetics" "anesthetics"  "centronics"   "gymnastics"  
#>  [5] "heuristics"   "onomastics"   "scientific's" "scientifics" 
#>  [9] "statistics'"  "stochastics"  "subsistence"  "synbiotics"
```

## CMU Pronouncing Dictionary

This package relies on the great Pronouncing Dictionary by CMU.

### CMU Pronouncing Dictionary Copyright notice

    CMUdict  --  Major Version: 0.07
    
    $HeadURL$
    $Date::                                                   $:
    $Id::                                                     $:
    $Rev::                                                    $:
    $Author::                                                 $:
    
    
    ========================================================================
    Copyright (C) 1993-2015 Carnegie Mellon University. All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    
    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
       The contents of this file are deemed to be source code.
    
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in
       the documentation and/or other materials provided with the
       distribution.
    
    This work was supported in part by funding from the Defense Advanced
    Research Projects Agency, the Office of Naval Research and the National
    Science Foundation of the United States of America, and by member
    companies of the Carnegie Mellon Sphinx Speech Consortium. We acknowledge
    the contributions of many volunteers to the expansion and improvement of
    this dictionary.
    
    THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND
    ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
    PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
    NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
    
    ========================================================================
