# site associated with this script at
# https://biodash.github.io/codeclub/s05e03/

# Intro ---------------------------------------

# you should have the tidyverse installed, but if not, do so using:
# install.packages("tidyverse")

# load the tidyverse
library(tidyverse)

# here is an example of non-tidy data, where there is *data embedded in column names*.
billboard


# here is an example of the same exact data, in a tidy format
# where those data that used to be column names, are now *values coded for a particular variable*.
billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )
  
# an example
# look at world_bank_pop using head
head(world_bank_pop)

# what if we want to make a plot to see how population has changed (y-axis) 
# for a specific country (say, the USA) over the duration for which data is collected (x-axis)? 
# With the data in this format, we cannot make this plot. 
# This is because **year** is not a column in our dataframe. 
# This population information is spread over all of the columns that have a year as their name.

# we can fix this by using `pivot_longer()`.
world_bank_pop_tidy <- world_bank_pop |> 
  pivot_longer(cols = !c(country, indicator), # which columns do we want to "pivot"
               names_to = "year", # where should the column names go
               values_to = "measure") # where should the values within each cell go

# check how this went
head(world_bank_pop_tidy)

# convert year from a character to a number so we can plot it 
world_bank_pop_tidy <- world_bank_pop_tidy |> 
  mutate(year = as.numeric(year))

# check again 
head(world_bank_pop_tidy)

# now we can make the plot we want. 
# a minimal plot
world_bank_pop_tidy |> 
  filter(country == "USA") |> 
  filter(indicator == "SP.POP.TOTL") |> 
  ggplot(aes(x = year, y = measure)) + 
  geom_point() +
  geom_line()

# a more polished plot
world_bank_pop_tidy |> 
  filter(country == "USA") |> 
  filter(indicator == "SP.POP.TOTL") |> 
  ggplot(aes(x = year, y = measure, color = country)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(limits = c(0, 4e8)) +
# ylim(c(0, 4e8)) + # also works instead of scale_y_continuous
  theme_minimal() +
  theme(legend.position = "none") +
  labs(x = "Year",
       y = "Population",
       title = "Total population in the United States \nfrom 2000 to 2017",
       caption = "Data from the World Bank")

# pivot_wider() -----------------------------------------

# what is in population?
head(population)


# what if we wanted to adjust the data so that instead of having a column called `year`, 
# the data for each year is its own column
# and have the corresponding `population` within each cell ? 
population_wide <- population |>
  pivot_wider(names_from = "year",
              values_from = "population")

head(population_wide)

# pivot_longer() -----------------------------------------

# we just made a wide dataframe with `pivot_wider()` - can we make it long again?
population_long <- population_wide |>
  pivot_longer(cols = !country, # all columns except country
               names_to = "year",
               values_to = "population")

head(population_long)

# other ways to do the same thing
population_long <- population_wide |>
  pivot_longer(cols = where(is.numeric), # all numeric columns
               names_to = "year",
               values_to = "population")

head(population_long)

population_long <- population_wide |>
  pivot_longer(cols = 2:20, # columns 2 through 20
               names_to = "year",
               values_to = "population")

head(population_long)


# Breakout Rooms -------------------------------------------
# download data
breed_rank_all <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_rank.csv')

### Exercise 1 
# Convert this data from wide format to long format.

### Exercise 2

# Take that new dataframe you've just made using `pivot_longer()` and make it wide again. 
# No, you can't just use the original dataframe 😀🐶


### Bonus 1
# Try making a plot that shows the rank popularity of your favorite dog breeds over 2013-2020.