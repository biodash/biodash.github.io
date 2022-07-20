## Load the tidyverse, which includes ggplot2:
library(tidyverse)

# 3.8: POSITION ADJUSTMENTS ----------------------------------------------------
## To colour bars, use `fill` rather than `colour`:
## (Note that we are mapping `x` and `colour`/`fill` to the same variable: `cut`)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))

## Now we'll map `fill` to a different variable, `clarity`.
## We automatically get a "stacked" bar chart:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))

## This stacking happens because the default "position adjustment" is `stack`:
?geom_bar

## Other position adjustments: (1) position = "identity" => no adjustment
## This is not useful for bar charts, but is the default for e.g. scatterplots.
## To even see what happens in case of bar charts, we'll make the bars transparent:
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +
  geom_bar(fill = NA, position = "identity")

## Other position adjustments: (2) position = "fill" => stacked & proportional
## This makes it easy to compare relative frequencies within each cut:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

## Other position adjustments: (3) position = "dodge" => bars beside one another
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

## Other position adjustments: (4) position = "jitter" to avoid overplotting
## This is useful for scatterplots and other plots that show individual points:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")


# EXERCISES FOR 3.8 ------------------------------------------------------------
## Exercise 1
## "What is the problem with this plot? How could you improve it?"
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

## Exercise 2
## What parameters to geom_jitter() control the amount of jittering?


# 3.9: COORDINATE SYSTEMS ------------------------------------------------------
## `coord_flip()` to switch x and y axis
## This graph has overlapping x labels:
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
## If we flip the axes, we no longer have that problem:
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()
## However, instead of using `coord_flip`, we can also simply "flip" our
## original mapping of x and y:
ggplot(data = mpg, mapping = aes(y = class, x = hwy)) +
  geom_boxplot()

## `coord_polar()` code example
## I'm not so interested in this coordinate function per se,
## but the code example in the book shows some other new & interesting features:
## 1: We can assign the plot to an "object" (`bar`) and modify it later
## 2: We can make changes to the look & feel of a plot using `theme()`
## 3: We can make changes to the plot labels using `labs()`
bar <- ggplot(data = diamonds) +
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()


# ADDENDUM: THEME() EXAMPLES AND GGSAVE() --------------------------------------
box <- ggplot(data = mpg, mapping = aes(y = class, x = hwy)) +
  geom_boxplot()

## Specific modifications with theme() (many different options!):
box + theme(panel.grid = element_blank())
box + theme(axis.title.x = element_text(size = 20))

## Complete themes - see https://ggplot2.tidyverse.org/reference/ggtheme.html:
box + theme_bw()
box + theme_bw(base_size = 14)
box + theme_dark()

## You can save a plot to disk with ggsave()
## (Just changing the extension in the filename will change the filetype!)
ggsave("my_boxplot.png", box)
ggsave("my_boxplot.jpeg", box)


# EXERCISES FOR 3.9 ------------------------------------------------------------
## Exercise 2
## What does labs() do? Read the documentation. [JP: and experiment with it a bit!]

## Exercise 4 (Bonus)
## - What does the plot below tell you about the relationship between city and highway mpg?
## - Why is coord_fixed() important?
## - What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()

