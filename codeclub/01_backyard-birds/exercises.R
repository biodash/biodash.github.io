library(tidyverse)

birds_file <- 'assets/data/birds/backyard-birds_Ohio.tsv'
birds <- read_tsv(birds_file)


# Create reading challenge for participants:
birds_challenge <- birds %>%
  slice_sample(n = 500) %>%
  select(order,
         species,
         lat = decimalLatitude,
         eventDate) %>%
  separate(eventDate, sep = "-", into = c('year', 'month', 'day'))

write_csv(birds_challenge, 'assets/data/birds/birds_read-challenge_orig.txt')
## + Manual edits: add a text line at the top, and a text line in the middle.

# Test reading:
birds_challenge <- read_csv(
  file = 'assets/data/birds/birds_read-challenge.txt',
  skip = 1,
  comment = '$',
  col_types = 'fcdiii'
)

str(birds_challenge)

birds_challenge <- read_csv(
  file = 'assets/data/birds/birds_read-challenge.txt',
  skip = 1,
  comment = '$',
  col_types = cols(
    order = col_factor(),
    year =  col_integer(),
    month = col_integer(),
    day = col_integer()
  )
)

str(birds_challenge)
