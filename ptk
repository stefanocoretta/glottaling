library(syllable)
library(textclean)
library(textshape)
library(lexicon)
library(tidyverse)

onesyllable <- subtlex %>%
  mutate(syl_number = count_vector(Spelling)) %>%
  filter(syl_number == '1')

target <- c('t', 'p', 'k')
ptk <- filter(onesyllable, substr(onesyllable$Spelling, nchar(onesyllable$Spelling) ,nchar(onesyllable$Spelling)) %in% target)

#     Alternative way to filter monosyllabic words: 
# subtlex <- subtlex %>%
# mutate(syl_number = unlist(count_vector(subtlex), use.names = F))
