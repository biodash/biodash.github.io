# 5.1 - INTRO ------------------------------------------------------------------
## Load packages
library(nycflights13)
library(tidyverse)

## Print the `flights` tibble
flights

## Compare this with how a regular data frame prints
mtcars


# 5.2 - FILTER -----------------------------------------------------------------
## Show only flights that departed on Jan 1st
filter(flights, month == 1, day == 1)

## Assign the result to a new dataframe
jan1 <- filter(flights, month == 1, day == 1)

## A little trick: assign _and_ print the result
(dec25 <- filter(flights, month == 12, day == 25))

## Make sure to use `==` and not `=` to test for equality
filter(flights, month = 1)

## Use the `|` (or) operator to find flights from Nov or Dec:
filter(flights, month == 11 | month == 12)

## Use the `%in%` operator to concisely specify multiple options:
nov_dec <- filter(flights, month %in% c(11, 12))

## See flights that weren't delayed (arr. or dep.) by more than 2 hours:
filter(flights, arr_delay <= 120, dep_delay <= 120)
filter(flights, arr_delay <= 120 & dep_delay <= 120)
filter(flights, !(arr_delay > 120 | dep_delay > 120))

## Operations with NAs tend to return NA:
NA > 5
NA + 10
NA == NA

## If you want to determine if a value is missing, use is.na():
is.na(x)

## If you want to keep rows with NAs, you need to specify this explicitly:
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)


# 5.3 - ARRANGE ----------------------------------------------------------------
## Arrange flights by year, then by month, and then by day:
arrange(flights, year, month, day)

## Use desc() to re-order by a column in descending order:
arrange(flights, desc(dep_delay))

## Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))
