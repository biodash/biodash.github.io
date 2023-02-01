## Breakout exercises pivot_longer:
#Question 1
#a) Create a dataset "table_pivot_long" from table1 with the following variables, country, year, population, type, and count. Hint use starts_with("case), values_to = "count"
#b) What is the dimension of table_pivot_long1?

#Solution question 1
# a)
table_pivot_long1 <- table1 |>
  pivot_longer(cols = starts_with("cases"), 
                            names_to = "type", 
                            values_to = "count")

# b)The dimension of table_pivot_long1 is 6 observations and 5 variables

#Question 2
#Compute rate per 10,000 for table_pivot_long1 and name the neww computed variable "rate". Hints use mutate, count, population

#Solution question 2
table_pivot_long1 |>
  mutate(rate = count / population *1000)
