



# Is the less than operator `<` vectorized?

# We used this example vector previously

(x <- c(2.1, 4.2, 3.3, 5.4))

# Let's double it by vectorization

# Recall that comparing this vector to some 'threshold' yields a logical vector:

x < 3

 #####
variable_power <- function(x, p){
  x**p
}

var_power(3, 3)

var_power_2 <- function(x, p = 2){
  x**p
}

var_power_2(2)
var_power_2(2, 3)
#####

# Write a function `equalish()` which compares two numbers `a` and `b`, and checks if they are 'equal enough' according to some threshold `epsilon`.

# Set a default threshold of 0.000001. The function should return TRUE if the absolute value of the difference is inside this threshold.

# Check that it works on a couple of test numbers.

# Now pass in a couple of test vectors. Is this new function vectorized?

# Now call the function explicitly with a different threshold.

equalish <- function(a, b, epsilon = 0.000001){
  abs(a - b) < epsilon
}

v1 <- c(4.00000000000000001, 2)
v2 <- c(4, 7)

equalish(v1, v2)

equalish(4.00000000000000001, 4)

equalish(2, 4)

# Intersection

my_intersect <- function(x, y){
  for (i in x){
    for (j in y){
      i == j
    }
  }
}

int1 <- c(1, 2, 3, 4, 5)
int2 <- c(3, 4, 5, 6, 7)

my_intersect(int1, int2)


new.function <- function(a,b,c) {
  a * b + c
  # print(result)
}

# Call the function by position of arguments.
new.function(5,3,11)

print("\150")

test <- c(65, 112, 112, 108, 101, 115)
intToUtf8(test)

test <- c(21 + 33, 27 + 33, 33 + 33, 43 + 33, 41 + 33, 1 + 33)
intToUtf8(test)

phred <- function(code){
  utf8ToInt(code) - 33
}

fastq(1:60)

phred("<>;##=><9=AAAAAAAAAA9#:<#<;<<<????#=")

utf8ToInt("TCGCACTCAACGCCCTGCATATGACAAGACAGAATC")


