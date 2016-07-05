# --------------------------------------------------------------
# DAY 6 Exercises: Munging
# --------------------------------------------------------------
# Mutate the airquality data to include the ratios of Ozone to Wind and Solar to 
# Temp. Display a summary of the results by reporting the min, max, mean, and 
# standard deviation of those ratios.

head(airqual_2)
airqual_2 <- airquality %>% mutate(OzoneWindRat = Ozone/Wind, SolarTempRat = Solar.R/Temp)

summary(airqual_2) #reports min, max, mean
lapply(airqual_2, sd, na.rm = T) #specify na.omit = T in sd() function, reports sd

# --------------------------------------------------------------
# Use the script below to do the following:
library(rvest)

movies = read_html("http://www.the-numbers.com/market/2015/top-grossing-movies")
movies.table = movies %>% html_nodes("table") %>% .[[1]] %>% html_table(fill = TRUE)
movies.table <- na.omit(movies.table)
summary(movies.table)
names(movies.table)[7:8] <- c("Gross", "TicketsSold")
str(movies.table)

# convert Gross to a numerical data type;
#### need to get rid of the dollar sign
?gsub
movies.tablev2 <- movies.table #it's good to make a clone of the initial data
#in case you make irreversible transformations.

movies.tablev2$Gross <- gsub("\\$","", movies.table$Gross) #to remove special characters, you'll need to type \\ in front of them. 

movies.tablev2$Gross <- gsub(",","",movies.tablev2$Gross)
movies.tablev2$Gross <- movies.tablev2$Gross %>% as.numeric

# summarise by reporting min, max, and mean Gross grouped by Genre;
movies.tablev2 %>% group_by(Genre) %>% summarise(min(Gross), max(Gross), mean(Gross))

# repeat the last item but for rating (MPAA) rather than Gross; and
# report any interesting findings.

head(movies.table)
movies.tablev2 %>% group_by(MPAA) %>% summarise(min(Gross), max(Gross), mean(Gross))

#--------------------------------------------------------
# Transform the data into the following format which gives the count of the number of records broken down by race, sex and eye colour.

library(tidyr)

people <- read.csv("peopledata.csv")
people %>% 
  group_by(Race, Sex) %>% 
  mutate(Count = n()) %>% 
  spread(Eye, Count, fill = 0) %>%
  select(Race, Sex, Blue, Brown, Green)

# Transform the data into the following format which gives the average height 
# broken down by race, sex and eye colour.

people %>%
  group_by(Sex, Eye) %>%
  mutate(Average = mean(Height)) %>% #specify average so it can be used in spread()
  spread(Race, Average) %>%
  select(-Height) #if you want to get rid of the initial Height variable
