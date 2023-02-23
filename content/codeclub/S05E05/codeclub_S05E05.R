# Setting up -------------------------------------------------------------------
# Packages
library(tidyverse)
install.packages("janitor")

# Downloading the practice files
url_csv <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students.csv"
download.file(url = url_csv, destfile = "students.csv")

url_csv_noheader <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students_noheader.csv"
download.file(url = url_csv_noheader, destfile = "students_noheader.csv")

url_csv_meta <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students_with_meta.csv"
download.file(url = url_csv_meta, destfile = "students_with_meta.csv")

url_tsv <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/students.tsv"
download.file(url = url_tsv, destfile = "students.tsv")



# Basics of reading files ------------------------------------------------------
students <- read_csv("students.csv")
students



# File locations ---------------------------------------------------------------
getwd()

# Demonstrate file browsing
""



# No column names --------------------------------------------------------------
# If there are no column names, the defaults will not work:
read_csv("students_noheader.csv")

# Option 1: Use 'col_names = FALSE':
read_csv("students_noheader.csv", col_names = FALSE)

# Option 2: Manually provide a vector of file names:
student_colnames <- c("student_id", "full_name", "fav_food", "meal_plan", "age")
read_csv("students_noheader.csv", col_names = student_colnames)



# Extra header or metadata lines -----------------------------------------------
# Option 1: skip a manually specified number of lines:
read_csv("students_with_meta.csv", skip = 2)

# Option 2: skip any line beginning with a "#"
read_csv("students_with_meta.csv", comment = "#")



# Missing value denotations ----------------------------------------------------
# Correctly parse missing values like so:
read_csv("students.csv", na = c("N/A", ""))

# Compare the result with those when using defaults only:
read_csv("students.csv")



# Crappy column names ----------------------------------------------------------
# Rename the columns 1-by-1 -- and use backticks for column names with spaces:
read_csv("students.csv") |>
  rename(student_id = `Student ID`)

# Or do it in one fell swoop with clean_names():
read_csv("students.csv") |>
  janitor::clean_names()



# Exercise pre-work ------------------------------------------------------------
# Exercise 2
url_tsv <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/exercise2.csv"
download.file(url = url_tsv, destfile = "exercise2.csv")

# Bonus exercise
# Install and load readxl
install.packages("readxl")
library(readxl)

# Download the practice file
url_xls <- "https://github.com/biodash/biodash.github.io/raw/master/content/codeclub/S05E05/breed_ranks.xlsx"
download.file(url = url_xls, destfile = "breed_ranks.xlsx")
