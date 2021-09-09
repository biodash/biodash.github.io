# Objects (make this a top level heading)

# Objects are things in R to which a name can be assigned. They’re created using the assignment operator “<-”, which can be thought of as an arrow.

x <- 3 + 3
y <- TRUE
z <- "cat"

# Functions (Make this a top level heading)

# It’s useful to be able to create your own functions. But if that sounds a little advanced to you at this point, you can still do a lot with R even without knowing how to write your own.

# Some example base R functions (make this a second level heading)

date()
getwd()
sqrt(25)

# Vectors (Make this a top level heading)

# Vectors in R share important characteristics.

# (Make the following three points a numbered list, and add emphasis using italics or boldface as you see fit).

# They’re one-dimensional. In other words, they can be defined by a length property, with length zero, one, or more.

# All elements of a vector must be of the same type, or class.

# Operations can be performed on vectors - vector recycling rules apply (we’ll see this in the breakout exercises next).

# (In the next paragraph, since the c() function is R code, use the inline code syntax to highlight it properly.)

# The c() function is useful for creating vectors in R. It stands for “combine”, and allows you to combine multiple items into a single vector object…


odds <- c(1,3,5,7,9)
animals <- c("dog", "cat", "cow")

odds

animals

class(odds)

class(animals)

# Now include the downloaded image using the appropriate syntax and experiment with the figure options.

# ![](path/to/figure.png)


