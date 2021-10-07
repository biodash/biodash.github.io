## Load the necessary packages
library(palmerpenguins)
library(tidyverse)


# 1 - A GEOM FOR BOXPLOTS ---------------------------------

## Our first attempt at a boxplot
ggplot(data = penguins) +
  geom_boxplot(mapping = aes(y = bill_length_mm))

## A separate box for each species
ggplot(data = penguins) +
  geom_boxplot(mapping = aes(y = bill_length_mm, x = species))


# 2 - ADDING A LAYER -------------------------------------

## TRYING to add a layer with the individual data points
ggplot(data = penguins) +
  geom_boxplot(mapping = aes(y = bill_length_mm, x = species),
               outlier.shape = NA) +
  geom_point()

## Adding a layer with the individual data points
ggplot(data = penguins,
       mapping = aes(y = bill_length_mm, x = species)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point()

## Jittering the data points
ggplot(data = penguins,
       mapping = aes(y = bill_length_mm, x = species)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1)


# BREAKOUT ROOMS I --------------------------------------


# 3 - INTRO TO FORMATTING PLOTS -------------------------

## Our starting point plot
ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70")


# 4 - FORMATTING WITH THEME ----------------------------

## Using a different "complete theme"
ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70") +
  theme_classic()

## Modifying the "complete theme"
ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70") +
  theme_classic(base_size = 14)

## Change individual aspects of a theme
ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70") +
  theme_classic(base_size = 14) +
  theme(axis.text = element_text(size = 14),
        axis.title = element_text(size = 14))

# 5 - ADDING PLOT LABELS --------------------------------

ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70") +
  theme_classic(base_size = 14) +
  labs(title = "Penguin Bill Length by Species",
       subtitle = "Collected at Palmer Station, Antarctica",
       x = "Penguin species",
       y = "Bill length (mm)")
