# Set up ------------------------------------

# Packages:
library(tidyverse)
library(readxl)
library(janitor)

# Files:
ioc_file <- 'assets/data/birds/master_ioc_list_v10.2.xlsx'
nomatch_file <- 'assets/data/birds/misc/english-names_nomatch.txt'
birds_file_in <- 'assets/data/birds/backyard-birds_Ohio_orig.tsv'

birds_file_out <- 'assets/data/birds/backyard-birds_Ohio.tsv'


# Add English names for matching Latin names -----------------------------------

# Read and process IOC file:
## I initially thought of filtering for North American (range "NA") birds only,
## ... but this get rids of all non-natives like House Sparrows and Starlings,
## ... because the ranges indicated are the native ones.
ioc <- read_xlsx(ioc_file, skip = 3) %>%
  clean_names() %>%
  select(genus,
         species_sc = species_scientific,
         species_en = species_english,
         range = breeding_range) %>%
  fill(genus, species_sc) %>%
  unite("species_sc_full", genus, species_sc, remove = FALSE, sep = " ")


# Read GBBC file and add English names:
birds <- read_tsv(birds_file_in) %>%
  mutate(species_en = ioc$species_en[match(species, ioc$species_sc_full)],
         range = ioc$range[match(species, ioc$species_sc_full)])


# Add English names for non-matching Latin names -------------------------------

# Non-matching -- I looked for non-matching Latin names and manually looked up the English names
## nomatch <- unique(birds$species[which(! birds$species %in% ioc$species_sc_full)])
## writeLines(nomatch, 'assets/data/birds/nomatch_orig.txt')
## ... Then added English names manually

# Get English names for non-matching:
nomatch_df <- read_delim(nomatch_file,
                         delim = '\t',
                         na = character()) # Prevent NA (North America) being read missing

birds <- birds %>%
  mutate(species_en2 = nomatch_df$species_en[match(species, nomatch_df$species_sc)],
         species_en = coalesce(species_en, species_en2),
         range2 = nomatch_df$range[match(species, nomatch_df$species_sc)],
         range = coalesce(range, range2)) %>%
  select(-species_en2, -range2)


# Check and write -----------------------------------------

# Check if it worked:
birds %>% filter(is.na(species_en)) # Only ones missing are hybrid ducks and birds not IDed to species

# Write birds file:
write_tsv(birds, birds_file_out)
