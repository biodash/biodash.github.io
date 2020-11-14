library(tidyverse)
library(readxl)
library(janitor)

## Read in IOC file:
ioc_file <- 'assets/data/birds/master_ioc_list_v10.2.xlsx'

ioc <- read_xlsx(ioc_file, skip = 3) %>%
  clean_names() %>%
  select(genus,
         species_sc = species_scientific,
         species_en = species_english,
         range = breeding_range) %>%
  fill(genus, species_sc) %>%
  #filter(str_detect(breeding_range, 'NA')) %>%
  unite("species_sc_full", genus, species_sc, remove = FALSE, sep = " ")

## Read in GBBC file:
birds_file <- 'assets/data/birds/backyard-birds_Ohio.tsv'
birds_no_english <- read_tsv(birds_file)

## Merge the two tibbles:
birds$species_en <- ioc$species_en[match(birds$species, ioc$species_sc_full)]
head(birds)

nomatch <- unique(birds$species[which(! birds$species %in% ioc$species_sc_full)])

writeLines(nomatch, 'assets/data/birds/nomatch.txt')
