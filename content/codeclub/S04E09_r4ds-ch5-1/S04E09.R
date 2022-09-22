# 5.1 - INTRO ------------------------------------------------------------------
## Load packages       # ...install first, if needed
library(nycflights13)  # install.packages("nycflights13")
library(tidyverse)     # install.packages("tidyverse")

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
(dec25 <- filter(flights, month == 12 & day == 25))

## Make sure to use `==` and not `=` to test for equality
filter(flights, month = 1) # Doesn't work

## Use the `|` (or) operator to find flights from Nov or Dec:
filter(flights, month == 11 | month == 12)

## Use the `%in%` operator to concisely specify multiple options:
filter(flights, month %in% c(9, 10, 11, 12))

## `%in%` tests if a value is _contained_ in a vector:
"a" %in% c("a", "b", "c")
c("a", "b") %in% c("a", "b", "c")

## Operations with NAs tend to return NA:
NA > 5
10 == NA
NA + 10
sum(c(4, 6, 7, NA), na.rm = TRUE)
NA == NA

## If you want to determine if a value is missing, use is.na():
x <- c(4,5,NA)
is.na(x)

## If you want to keep rows with NAs, you need to specify this explicitly:
df <- tibble(x = c(1, NA, 3))
df
filter(df, x > 1)
filter(df, x > 1 | is.na(x))
