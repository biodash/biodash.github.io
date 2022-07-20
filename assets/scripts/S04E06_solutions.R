# 3.8 - EXERCISE 1 -------------------------------------------------------------
#? "What is the problem with this plot? How could you improve it?"
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()

#> - The plot suffers from "overplotting": points are hidden behind one another.
#> - To avoid this, use the position adjustment "jittering":
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")

#> - Similarly, you can also use the `geom_jitter()` shorthand:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()


# 3.8 - EXERCISE 2 -------------------------------------------------------------
#? What parameters to geom_jitter() control the amount of jittering?

#> - Let's check the documentation:
?geom_jitter

#> - The amount of jittering (displacement) is controlled by the arguments
#>   `width` (horizontal jittering) and `height` (vertical jittering).

#> - In the example below, our plot has a lot more jittering than before:
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 10, height = 10)


# 3.9 - EXERCISE 2 -------------------------------------------------------------
#? What does labs() do? Read the documentation. [JP: and experiment with it a bit!]

#> - The labs() function allows you to control the main plot labels,
#>   such as the plot title & subtitle, and the x- and y-axis titles.

#> - We'll make a boxplot and look at the defaults first:
p_box <- ggplot(data = mpg, mapping = aes(x = hwy, y = class)) +
  geom_boxplot()
p_box

#> - Let's make some modifications!
p_box +
  labs(x = "Highway mileage (miles per gallon, mpg)",
       y = NULL,
       title = "Comparison of mileage among major classes of cars",
       subtitle = "SUVs and pickups perform poorly",
       tag = "A",
       caption = "Source: http://fueleconomy.gov")

#> - The above example (& the example in the book) also shows that
#>   if you want to omit a label that is shown by default, such as the x- or
#>   y-axis title, you can set it to `NULL`.


# 3.9 - EXERCISE 4 (BONUS) -----------------------------------------------------
#? - What does the plot below tell you about the relationship between city and highway mpg?
#? - Why is coord_fixed() important?
#? - What does geom_abline() do?
p_mileage <- ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()
p_mileage

#> Among cars, city and highway gas mileage are strongly correlated, as expected.
#> In addition, city gas mileage is worse than highway gas mileage:
#> for example, for a city mpg of 20, the highway mpg is about 25-30.

#> geom_abline() helps us see that the relationship between city and highway
#> mpg does not have a slope of 1, as discussed above.
#> By default, geom_abline() draws a line through the origin with a slope of 1
#> This will make it easy to compare values along the x and y axes
#> (Unfortunately, the documentation doesn't make the defaults fully clear:)
?geom_abline()
#> We can modify the axis limits to make this clearer:
p_mileage +
  scale_x_continuous(limits = c(0, 45)) +
  scale_y_continuous(limits = c(0, 45))

#> coord_fixed() ensures that 1 unit along the x axis takes up the same amount
#> of space as 1 unit along the y-axis, which also makes it easier to judge the
#> slope of the relationship.
#> In practice, this means that because there is a larger range of values
#> along the y-axis (from 12 to 44) than along the x-axis (from 9 to 35),
#> the graph is higher than it is wide.
#> This example should make the role of coord_fixed() clearer:
ggplot(data = mtcars, mapping = aes(mpg, wt)) +
  geom_point() +
  coord_fixed()
