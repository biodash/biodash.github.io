## Install packages if needed
## (`require(glue)` returns FALSE if glue isn't installed; therefore,
##  these lines will only try to install packages that aren't already installed.)
if (!require(palmerpenguins)) install.packages("palmerpenguins")
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(broom)) install.packages("broom")
if (!require(glue)) install.packages("glue")
if (!require(factoextra)) install.packages("factoextra")

## Load the packages into your R session
library(palmerpenguins)
library(tidyverse)
library(broom)
library(glue)
library(factoextra)

## Prep the penguin data for the PCA: remove NA and select the 4 numeric columns
penguins_noNA <- drop_na(penguins)
penguins_for_pca <- penguins_noNA %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)

## How much data do we have?
dim(penguins_for_pca)

## Run the PCA
pca <- prcomp(penguins_for_pca, scale = TRUE)

## Check the output
class(pca)

pca           # Returns a summary of sorts
summary(pca)  # ...Another summary of sorts
str(pca)      # A look at what's actually contained in the object

pca$sdev      # Eigenvalues - amount of variation explained by each PC
pca$rotation  # Variable loadings for each PC
head(pca$x)   # Sample scores for each PC
pca$center    # Vector with variables means
pca$scale     # Vector with scaling constants

## Scree plot
plot(pca)

## Score (classic PCA) plot
pca_scores <- bind_cols(data.frame(pca$x), penguins_noNA) # Include the "metadata"

score_plot <- ggplot(pca_scores) +
  geom_point(aes(x = PC1, y = PC2, color = species)) +
  theme_classic()
score_plot

## Improve the score plot: change aspect ratio and add % explained by each PC
pca_eigen <- tidy(pca, matrix = "eigenvalues")
PC1_percent <- round(pca_eigen$percent[1] * 100, 1)
PC2_percent <- round(pca_eigen$percent[2] * 100, 1)

score_plot <- score_plot +
  theme(aspect.ratio = PC2_percent / PC1_percent,
        legend.position = "top") +
  labs(x = glue("PC1 ({PC1_percent}%)"),
       y = glue("PC2 ({PC2_percent}%)"))
score_plot

## Biplot
fviz_pca(pca,
         label = "var",                       # Show labels for variables only
         habillage = penguins_noNA$species) + # color by / shape by
  theme(legend.position = "top")

