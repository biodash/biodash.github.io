
Name <- c("kim", "sandy", "lee")
Age <- c(23, 21, 26)

df <- data.frame(Name, Age)

str(df)

list <- list(c("kim", "sandy", "lee"), c(23, 21, 26))

str(list)

named_list <- list(Name = c("kim", "sandy", "lee"), Age = c(23, 21, 26))

str(named_list)

typeof(named_list)

df <- as.data.frame(named_list)

str(df)

tibble <- as_tibble(named_list)

select(df, Name)
pull(df, Name)

select(df, Name) %>%
  typeof()

pull(df, Name) %>%
  typeof()

pull(df, Age) %>%
  typeof()

df[1]

df[1] %>%
  typeof()

df[[1]]

df[[1]] %>%
  typeof()

df["Age"]

df[["Age"]]

df$Age

select(named_list, Age)

# Anova

bill_length_anova <-
  aov(data = penguins %>% drop_na(),
      bill_length_mm ~ species + sex + species*sex)

bill_length_anova

str(bill_length_anova)

tidy_anova <- broom::tidy(bill_length_anova)

as.data.frame(bill_length_anova)
