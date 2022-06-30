## Load libraries
library(tidyverse)

## Data
## This chapter is using the `mpg` dataset. Let's see what's in there.
glimpse(mpg)

# Facets
## To facet your plot by a single variable, use facet_wrap()
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

## To facet your plot on the combination of two variables, add facet_grid()
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Exercises

## 3.5.1 continuous variable
### What happens if you facet on a continuous variable?
### Let's look back at `mpg` to see which are continuous variables (i.e. doubles/numeric) 
### and which are factors, integers, characters, etc.
glimpse(mpg)





## 3.5.2 empty cells
### What do the empty cells in plot with `facet_grid(drv ~ cyl)` mean? How do they relate to this plot?




### You could also answer this question using dplyr and tidyverse wrangling tools 
### which to me is more intuitive:


## 3.5.3 `.`
### What plots does the following code make? What does . do?





## 3.5.4 Facets vs. other aesthetics
### Take the first faceted plot in this section:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

### What are the advantages to using faceting instead of the colour aesthetic? 
### What are the disadvantages? 
### How might the balance change if you had a larger dataset?





## 3.5.5 `ncol` and `nrow` in `facet_wrap`
### Read `?facet_wrap`. What does nrow do? 
### What does ncol do? 
### What other options control the layout of the individual panels? 
### Why doesn’t facet_grid() have nrow and ncol arguments?





## 3.5.6 Variable with more levels as columns
### When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?





# Geometric objects (i.e. geoms)
## geom_point or a scatterplot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

## geom_smooth or smoothed conditional means
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

## changing linetype
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

## more geom_smooth
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
  
## adding group
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

## removing legend
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

## putting it all together
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

## but with less redundancy
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

## adding different aesthetics per geom
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

## having different data in each layer
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

## Exercises

## 3.6.1 Investigating geoms
###  What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?

### Line chart


### Boxplot


### Histogram


### Area chart

## 3.6.2 Mind coding
### Run this code in your head and predict what the output will look like. 
### Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)




## 3.6.3 show.legend = FALSE
### What does show.legend = FALSE do? What happens if you remove it?
### Why do you think I used it earlier in the chapter?

#### With legend



#### Without legend



## 3.6.4 `se`
### What does the se argument to geom_smooth() do?


### Is `se = TRUE` the default? How would you know?

## 3.6.5 Will graphs look different?
### Will these two graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))



## 3.6.7 Code from plots
### Recreate the R code necessary to generate the following graphs.

#### Graph 1



#### Graph 2



#### Graph 3



#### Graph 4



#### Graph 5



#### Graph 6
