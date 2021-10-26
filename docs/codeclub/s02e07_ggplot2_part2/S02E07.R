## Load packages


# 1 - A GEOM FOR BOXPLOTS ---------------------------------

## Taking a look at the dataframe


## Our first attempt at a boxplot


## Checking what the warning is about


## A separate box for each species



# 2 - ADDING A LAYER -------------------------------------

## TRYING to add a layer with the individual data points


## Adding a layer with the individual data points


## Jittering the data points



# BREAKOUT ROOMS I --------------------------------------

## Bad code
ggplot(data = penguins,
       aes(y = bill_length_mm, x = species)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(mapping = aes(color = "blue"),
             position = "jitter")

## Good code


## Violin plot
a

# 3 - INTRO TO FORMATTING PLOTS -------------------------

## A starting plot



# 4 - FORMATTING WITH THEME ----------------------------

## Using a different "complete theme"

## Modifying the "complete theme"

## Change individual aspects of a theme



# 5 - ADDING PLOT LABELS --------------------------------



# BREAKOUT ROOMS II --------------------------------------

## Starting plot
ggplot(data = penguins,
       mapping = aes(x = species, y = bill_length_mm)) +
  geom_boxplot(outlier.shape = NA) +
  geom_point(position = "jitter", size = 1, color = "grey70") +
  theme_bw(base_size = 14) +
  labs(title = "Penguin Bill Length by Species",
       subtitle = "Collected at Palmer Station, Antarctica",
       x = "Penguin species",
       y = "Bill length (mm)")

## Modify complete theme and theme settings

## Color points by sex and move legend
