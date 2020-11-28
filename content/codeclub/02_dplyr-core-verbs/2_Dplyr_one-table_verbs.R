# Learning dplyr core verbs
# https://dplyr.tidyverse.org/
# by Jessica Cooperstone

# load packages
library(tidyverse)

# grab data from base R
iris_data <- iris

# look at data frame
View(iris_data)

# explore structure
glimpse(iris_data)

# select
# picks variables (i.e., columns) based on their names
iris_petals_species <- iris_data %>%
  select(Species, Petal.Length, Petal.Width)

View(iris_petals_species)
# note - what happened to the order?

# filter
# picks observations (i.e., rows) based on their values
iris_setosa <- iris_data %>%
  filter(Species == "setosa")

head(iris_setosa)

# mutate
# makes new variables, keeps existing columns
iris_sepal_length_to_width <- iris_data %>%
  mutate(Sepal.Length_div_Sepal.Width = Sepal.Length/Sepal.Width)
# note - where did the column go?

# arrange
# sorts rows based on values in columns
iris_data %>%
  arrange(Sepal.Length)

# what if i want to arrange, but grouping by species?
# group_by() is a very useful little helper
iris_data %>%
  group_by(Species) %>%
  arrange(Sepal.Length)

# summarize
# reduces values down to a summary form
iris_data %>%
  group_by(Species) %>%
  summarize(mean = mean(Sepal.Length))

# integrating across() with summarize
# my favorite version of summarize
iris_data %>%
  group_by(Species) %>%
  summarize(across(where(is.numeric), mean))

# how many iris observations of each species do we have?
iris_data %>%
  group_by(Species) %>%
  tally()

#################
# now you try!
# we will be using the birds data from the week before thanksgiving
# if you weren't here then and haven't downloaded that data, you can do so like this:
# don't do this if you were here, because you already have these directories
dir.create('S02')

# Dir for our bird data:
# ("recursive" to create two levels at once.)
dir.create('data/birds/', recursive = TRUE)

## Download data
# The URL to our file:
birds_file_url <- 'https://raw.githubusercontent.com/biodash/biodash.github.io/master/assets/data/birds/backyard-birds_Ohio.tsv'

# The path to the file we want to download to:
birds_file <- 'data/birds/backyard-birds_Ohio.tsv'

# Download:
download.file(url = birds_file_url, destfile = birds_file)

#### START HERE IF YOU CAME TO THE FIRST CODE CLUB SESSION
## Read in data
# The path to the file we want to download to:
birds_file <- 'data/birds/backyard-birds_Ohio.tsv'
birds <- read_tsv(birds_file)

# what is birds all about?
# use head() to look at the first 6 rows, all columns
head(birds)

# a tidy way to look at the structure of your data


# create a new dataframe which removes the range column

# how many unique species have been observed?


# how many times has a Bald Eagle observed?

# how many times has any kind of eagle been observed?
# i will tell you that there are only Bald Eagle and Golden Eagle in this df


# what is the north most location of a bird observation in Ohio?


# what is the most commonly observed bird species?


# what is the least commonly observed bird species?


## bonus material
# in what year were the most Bald Eagles observed?




