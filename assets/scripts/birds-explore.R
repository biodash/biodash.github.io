# Packages:
library(tidyverse)


# Files:
birds_file <- 'assets/data/birds/backyard-birds_Ohio.tsv'


# Read the data:
system.time(birds <- read_tsv(birds_file))
#system.time(birds2 <- read.delim(birds_file))
#system.time(birds3 <- read.table(birds_file, sep = '\t', header = TRUE))
#system.time(birds4 <- data.table::fread(birds_file))


# Some processing:
birds <- birds %>%
  select(-class, -stateProvince) %>% # These don't vary
  rename(lat = decimalLatitude,      # Unwieldy names
         lon = decimalLongitude,
         date = eventDate)


# Explore:
table(birds$date)
length(unique(birds$species))
unique(birds$species)

birds %>% filter(is.na(species)) # A few records were not ID'ed to species level


# Locations
#TBA


# How many bird orders were recorded?
birds %>% distinct(order) %>% nrow()
birds %>% summarise(n_distinct(order)) # Alt


# How many unique values in each column?
birds %>% summarise(across(everything(), n_distinct))
apply(birds, 2, function(x) length(unique(x))) # Alt


# How many records for each bird order?
birds %>% count(order)


# What is the most common species (i.e., most occurrences across rows) overall?
birds %>% count(species) %>% arrange(n) %>% tail(1)


# What is the most common species for each year?
yr_counts <- birds %>%
  mutate(year = year(date)) %>%
  group_by(year, species) %>%
  summarise(yr_count = n())

yr_counts %>%
  group_by(year) %>%
  slice_max(yr_count, n = 1)


# Extract just the 2nd most common species,
# in such a way that you could easily switch to any X'nd most common species.
yr_counts <- birds %>%
  mutate(year = year(date)) %>%
  group_by(year, species) %>%
  summarise(yr_count = n())

yr_counts %>%
  mutate(yr_rank = rank(desc(yr_count))) %>%
  filter(yr_rank == 2)


# How many species were seen only once?
birds %>% count(species) %>% filter(n == 1) %>% nrow()


# Remove species seen fewer than a 100 times:
common_species <- birds %>% count(species) %>% filter(n >= 100) %>% pull(species)
birds_common <- birds %>% filter(species %in% common_species)


# Dates: extract year/month/day
library(lubridate)
birds %>% pull(date) %>% year() %>% table()
birds %>% pull(date) %>% month() %>% table()
birds %>% pull(date) %>% day() %>% table()

# Dates: get rid of times as all are 00:00:00
birds %>% mutate(date = as_date(date)) # Convert date-time to date

# What if our dates were just character strings and we wanted to extract y/m/d?
birds %>%
  mutate(date2 = as.character(date)) %>%
  separate(date2, sep = "-", into = c('year', 'month', 'day'))

# Which birds have increased most in first 2 vs last 2 years?
# And which ones have decreased most?
birds_sel <- birds %>%
  mutate(year = year(date)) %>%
  filter(year %in% c(1998, 1999, 2008, 2009)) %>%
  mutate(year_grp = ifelse(year %in% c(1998, 1999), 'y98_99', 'y08_09'))

birds_abund <- birds_sel %>%
  select(species, year_grp) %>%
  count(species, year_grp) %>%
  inner_join(
    .,
    count(birds_sel, year_grp, name = 'year_total'),
    by = 'year_grp'
    ) %>%
  mutate(obs_per_1k = (n / year_total) * 1000 ) %>%
  select(-year_total, -n)

birds_abund_change <- birds_abund %>%
  pivot_wider(id_cols = species,
              names_from = year_grp,
              values_from = obs_per_1k) %>%
  filter(y98_99 > 1) %>% # Exclude not-so-common species, changes across year probably not so informative
  mutate(
    increase = ifelse(
      y08_09 > y98_99,
      ((y08_09 - y98_99) / y98_99) * 100,
      - ((y98_99 - y08_09) / y08_09) * 100
      )
    )

birds_abund_change %>% slice_min(increase, n = 10)
birds_abund_change %>% slice_max(increase, n = 10)
