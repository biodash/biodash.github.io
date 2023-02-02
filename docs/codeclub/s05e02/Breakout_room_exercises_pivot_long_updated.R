library(tidyverse)
Metabolite <- read_csv("Metabolite.csv")

#Metabolite data is made of peaks from Mass spectrometer experiments on soybeans attacached by aphids.
#10 peaks from 38 metabolites
Metabolite <- read_csv("Metabolite.csv")
#Exercise 1
#Create a dataframe Metabolite_Long from Metabolite dataset with the following variables: Soy_Metabolite,
#Peak1 to Peak 10.

#Hint, Use starts_with("Peak), values_to = "count"

#Solution
Metabolite_Long <- Metabolite |>
  pivot_longer(cols = starts_with("Peak"), 
               names_to = "type", 
               values_to = "count")

#What are the number of rows and columns of Metabolite_Long?
#Solution dim(Metabolite_Long)

#Exercise 2
#Compute the count per 10,000 by diving count with 10,000 for Metabolite_Long, and name the new computed variable count_10000
#Hint Use the mutate() function similar to the first example with mutate() in this session.

#Solution
Metabolite_Long |>
  mutate(rate_10000 = count /1000)
