# ggplot2, part 2
# https://ggplot2.tidyverse.org/ 
# by Jessica Cooperstone

# load libraries
library(tidyverse)

# install palmerpenguins
# https://allisonhorst.github.io/palmerpenguins/authors.html
install.packages("palmerpenguins")
library(palmerpenguins)
data(package = 'palmerpenguins')

# look at the two dfs in palmerpenguins
glimpse(penguins)
glimpse(penguins_raw)

dim(penguins) # check dimension

# remove NAs
penguins_noNA <- penguins %>%
  drop_na()

dim(penguins_noNA) # we have removed 11 observations

# calculating mean bill_length_mm by species
penguins_noNA %>%
  group_by(species) %>%
  summarize(mean_bill_length = mean(bill_length_mm))

# bar plot with geom_col()
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm)) +
  geom_col()
# this isn't what we want - look at the y-axis scale

# bar plot, the right way with geom_col()
penguins_noNA %>%
  group_by(species) %>%
  summarize(mean_bill_length = mean(bill_length_mm)) %>%
  ggplot(aes(x = species, y = mean_bill_length)) +
  geom_col()

# or you could do this in a less bulky way with stat_summary()
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm)) +
  stat_summary(fun = "mean", geom = "bar")

# but friends don't let friends make dynamite plots
# https://simplystatistics.org/2019/02/21/dynamite-plots-must-die/
# so let's boxplot instead
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm)) +
  geom_boxplot()

penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm)) +
  geom_boxplot() +
  coord_flip()

# you could also flip coordinates by switching x and y

# violin plot
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, color = species)) +
  geom_violin()

# violin plot with data points overlaid
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, fill = species)) +
  geom_violin() +
  geom_point()

# violin plot with data points jittered
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, fill = species)) +
  geom_violin() +
  geom_jitter(width = 0.2, height = 0)

# dotplots
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, fill = species)) +
  geom_dotplot(binaxis = "y", stackdir = "center", dotsize = 0.4)

# density plots
install.packages("ggridges")
library(ggridges)
penguins_noNA %>%
  ggplot(aes(x = bill_length_mm, y = species, fill = species)) +
  geom_density_ridges(alpha = 0.8)

# mapping to additional aesthetics
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, 
             color = sex, 
             shape = island, 
             group = species)) +
  geom_violin() +
  geom_jitter(width = 0.2, height = 0)

# making pretty with theme() and clear labs()
penguins_noNA %>%
  ggplot(aes(x = species, y = bill_length_mm, 
             color = sex, 
             shape = island, 
             group = species)) +
  geom_violin() +
  geom_jitter(width = 0.2, height = 0,) +
  theme_classic() +
  labs(title = "Penguin Bill Length by Species, Sex and Location",
       subtitle = "Collected at Palmer Station, Antarctica",
       x = "Penguin Species",
       y = "Bill length (mm)",
       color = "Sex",
       shape = "Island")

#### EXERCISES
library(NHANES)
glimpse(NHANES)

# Exercise 1
# alter NHANES so it only includes people over 20 years old
# remove NAs if they exist in TotalChol or AgeDecade
# here are a few ways to do this
NHANES_over20_noNA <- NHANES %>%
  filter(Age >20) %>%
  drop_na(AgeDecade, TotChol)

dim(NHANES_over20_noNA)

#> [1] 6408   76


NHANES_over20_noNA <- NHANES %>%
  filter(Age >20,
         !is.na(AgeDecade),
         !is.na(TotChol))

dim(NHANES_over20_noNA)

# Exercise 2
# make a boxplot showing total cholesterol (TotChol) by age, subdivided into decades (AgeDecade)
NHANES_over20_noNA %>%
  ggplot(aes(x = AgeDecade, y = TotChol)) +
  geom_boxplot()

# Exercise 3
# make Exercise 2 a violin plot instead of a boxplot and color by AgeDecade
NHANES_over20_noNA %>%
  ggplot(aes(x = AgeDecade, y = TotChol, color = AgeDecade)) +
  geom_violin()

NHANES_over20_noNA %>%
  ggplot(aes(x = AgeDecade, y = TotChol, fill = AgeDecade)) +
  geom_violin()

# Exercise 4
# combine the boxplot and violin
# adjust your plot so that you think the boxplot and violin plots look good
NHANES_over20_noNA %>%
  ggplot(aes(x = AgeDecade, y = TotChol, color = AgeDecade)) +
  geom_violin() +
  geom_boxplot(width = 0.2)

# Exercise 5
# overlay your data points on top of your violin plot
# add plot labels and a title
NHANES_over20_noNA %>%
  ggplot(aes(x = AgeDecade, y = TotChol, color = AgeDecade)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(width = 0.3, alpha = 0.1) +
  labs(title = "Total Cholesterol by Age",
       subtitle = "Data from the National Health and Nutrition Examination Survey (NHANES)",
       x = "Age, by Decade",
       y = "Total Cholesterol, mmol/L",
       color = "Age (years)")

# Bonus time!

# Bonus 1
# make a density ridge plot of Totchol by AgeDecade
install.packages("ggridges")
library(ggridges)
NHANES_over20_noNA %>%
  ggplot(aes(x = TotChol, y = AgeDecade, fill = AgeDecade)) +
  geom_density_ridges(alpha = 0.7) 

# Bonus 2
# check out different themes available through hrbrthemes
# apply themes to your density ridge plot from Bonus 1
# try theme_ipsum_rc()
install.packages("hrbrthemes")
library(hrbrthemes)
NHANES_over20_noNA %>%
  ggplot(aes(x = TotChol, y = AgeDecade, fill = AgeDecade)) +
  geom_density_ridges(alpha = 0.7, scale = 0.9) +
  theme_ipsum_rc() 

# Bonus 3
# give your plot from Bonus 2 a title, fix plot labels
# add the median TotChol for each AgeDecade
NHANES_over20_noNA %>%
  ggplot(aes(x = TotChol, y = AgeDecade, fill = AgeDecade)) +
  geom_density_ridges(alpha = 0.7, scale = 0.9) +
  stat_summary(fun = median) +
  theme_ipsum_rc() +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5)) +
  labs(title = "Total Cholesterol by Age",
       subtitle = "Data from the National Health and Nutrition Examination Survey (NHANES)",
       x = "Total Cholesterol, mmol/L",
       y = "Age, by Decade",
       fill = "Age (years)")

# Bonus 4
# take your plot from Bonus 3 and add a line for normal cholesterol cutoff
# normal cholesterol is <5.2 mmol/L
NHANES_over20_noNA %>%
  ggplot(aes(x = TotChol, y = AgeDecade, fill = AgeDecade)) +
  geom_density_ridges(alpha = 0.7, scale = 0.9) +
  stat_summary(fun = median) +
  geom_vline(aes(xintercept = 5.2)) +
  theme_ipsum_rc() +
  theme(axis.title.x = element_text(hjust = 0.5),
        axis.title.y = element_text(hjust = 0.5)) +
  labs(title = "Total Cholesterol by Age",
       subtitle = "Data from the National Health and Nutrition Examination Survey (NHANES)",
       caption = "Vertical line indicates upper limit of normal cholesterol",
       x = "Total Cholesterol, mmol/L",
       y = "Age, by Decade",
       fill = "Age (years)")