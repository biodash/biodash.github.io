#load tidyverse (this assumes you've already installed it)
library(tidyverse)

#install, load, and preview the example dataset
install.packages("NHANES")
library(NHANES)
glimpse(NHANES)

#Filter out rows with data from 2009-2010 and Age > 5, select a subset (4) of the variables, then get rid of all duplicate rows. Assign the output to object 'dem_data'.
dem_data <- NHANES %>% filter(SurveyYr == "2009_10") %>% filter(Age > 5) %>% 
			select(ID, Gender, Age, Education) %>% distinct()
#similar as above, but with a different filter and selecting different variables. Save as 'phys_data'
phys_data <- NHANES %>% filter(SurveyYr == "2009_10") %>% filter(Height < 180)  %>%
			select(ID, Height, BMI, Pulse) %>% distinct()
			
#view the first 6 rows of each - note the shared ID column
head(dem_data)
head(phys_data
#preview in another way - note the different numbers of observations (rows)
glimpse(dem_data)
glimpse(phys_data)

#perform an inner join
join_inner <- inner_join(dem_data, phys_data, by = "ID") 
#preview the new object
head(join_inner)
#get dimensions
dim(join_inner)

#perform a left join
join_left <- left_join(dem_data, phys_data, by = "ID") 
#preview the new object
head(join_left)
#get dimensions
dim(join_left)

#perform a right join
join_right <- right_join(dem_data, phys_data, by = "ID") 
#preview the new object
head(join_right)
#get dimensions
dim(join_right)

#perform a full join
join_full <- full_join(dem_data, phys_data, by = "ID") 
#preview the new object
head(join_full)
#get dimensions
dim(join_full)