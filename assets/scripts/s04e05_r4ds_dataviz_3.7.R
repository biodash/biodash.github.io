# Load libraries
library(tidyverse)

# Preview Data: Instead of the `mpg` dataset we've been using in the past few sessions, this section uses the `diamonds` dataset. Like `mpg`, this is included in the *ggplot2* package, which gets loaded as part of the *tidyverse*, so it should already be available to us. Let's first explore that dataset a bit.

glimpse(diamonds)

#OR

head(diamonds)


# 3.7 Statistical Transformations

#As we talked about in previous sessions, *ggplot* allows you to build plots layer by layer. A common way to add layers is with *geoms* - geometric objects that represent data. And when we add a geom to a plot, we need to define what data will be represented. This link is made by connecting *ggplot*'s *aesthetics* to specific variables in the data. We saw some examples of that last week. 

# Scatter Plot From Last Week

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#But in some cases you might want a geom to represent some transformed version of the data associated with a variable. *ggplot* has a number of *stats*, or statistical transformations, that perform these data transformations "on the fly" and plot the transformed values. Some commonly-used examples include binning and counting associated with bar plots or histograms and calculating and plotting predictive lines of best fit through a set of continuous data points.

# Bar Plot Examples

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

#Or create the same plot with the stat_count() function/stat - stats and their associated geoms can often be used interchangeably.

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

#The stat used can be changed...

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

#Under the hood, `stat_count()` calculates both "count" and "prop" variables (see the "Computed Variables" section in the documentation for `stat_count()`). By default, "count" is mapped to the y aesthetic for `geom_bar()`, but you can choose "prop" instead...

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))


#`stat_summary()` summarizes y values for each unique x value.

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )


#3.7.1 Exercises

#3.7.1.1

#What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?

# 3.7.1.2

#What does geom_col() do? How is it different to geom_bar()?


# 3.7.1.3

#Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?


# 3.7.1.4

#What variables does stat_smooth() compute? What parameters control its behaviour?


# 3.7.1.5

#In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))