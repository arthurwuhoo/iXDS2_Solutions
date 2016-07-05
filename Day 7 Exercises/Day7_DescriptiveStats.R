# -------------------------------------------------------------------------------
# DAY 7 Exercises: Descriptive Statistics
# -------------------------------------------------------------------------------
# Write functions Mean() and Median() which calculate the mean and median of their arguments.

Mean <- function(x) {
  Mean <- sum(x)/length(x)
  return(Mean)
}

test_vec <- c(10, 8, 6, 4, 2, 9, 7, 5, 3, 1)
Mean(test_vec)


Median <- function(x) {

  new_vec <- x
  sorted_vec <- sort(new_vec)
  if(length(x)%%2 == 0){

    leftindex <- floor(length(sorted_vec)/2)
    rightindex <- leftindex + 1
    value <- mean(c(sorted_vec[leftindex], sorted_vec[rightindex]))

  }
  else {
  middleindex <- floor(length(sorted_vec)) + 1
  value <- sorted_vec[middleindex]
  }
  return(value)
}

Median(test_vec)

# -------------------------------------------------------------------------------
# Look at the precip and islands data in the datasets package.
# Summarise each of these by calculating the mean and median. First use Mean() and Median(). Compare those results with what you get from mean() and median(). Are the results the same?

library(datasets)
islands
precip

Mean(islands)
mean(islands)
Median(islands)
median(islands)

# For one set of data the mean and median are similar, while for the other they differ 
# substantially. Why? You might find it helpful to look at the distribution of the data
# as a histogram using hist(). You can use abline() to superimpose vertical lines for 
# the mean and median.

#trick shot to see two graphs at once
par(mfrow=c(2,1))

hist(islands) #mean probably much higher than the median here
abline(v = mean(islands), col = "red")
abline(v = median(islands), col = "blue")


hist(precip) #mean is more close to the median
abline(v = mean(precip), col = "red")
abline(v = median(precip), col = "blue")


# -------------------------------------------------------------------------------
# We're going to be looking at the flights data now.
# Pick three major U.S. cities.
# Create a data frame for each city that contains only those flights originating from #or arriving at that city.

# Use summary() to compare the quantiles of delay time between the city datasets.
# Use boxplot() to visualise the delay times for all three cities on the same plot. What do you notice? What surprises you about the data, if anything?

library(readr)
library(dplyr)
flights <- read_csv("Airlines Data March 2016.csv")

#JFK
jfk <- flights  %>% filter(DEST == "JFK" | ORIGIN == "JFK")

#ATL
atl <- flights  %>% filter(DEST == "ATL" | ORIGIN == "ATL")

#LAX 
lax <- flights  %>% filter(DEST == "LAX" | ORIGIN == "LAX")

summary(jfk$DEP_DELAY)
summary(atl$DEP_DELAY)
summary(lax$DEP_DELAY)

par(mfrow=c(1,1))
boxplot(jfk$DEP_DELAY, lax$DEP_DELAY, atl$DEP_DELAY) #hard to tell in this format
#what most of the departure delay data really looks like.

jfk_delays <- quantile(jfk$DEP_DELAY, na.rm = T)[1:4] #gets the values for 0% to 75% quantiles
atl_delays <- quantile(atl$DEP_DELAY, na.rm = T)[1:4] #gets the values for 0% to 75% quantiles
lax_delays <- quantile(lax$DEP_DELAY, na.rm = T)[1:4] #gets the values for 0% to 75% quantiles

jfk_delays
atl_delays
lax_delays

# -------------------------------------------------------------------------------
# CHALLENGE:
# Delay Time by Weekday for all NYC Airports: Construct a visualisation of the 
# distribution of delay times for each NYC airport broken down by weekday. So, for 
# example, it would include the delay times for JFK on Mondays. Subsetting these data 
# might take a bit of work. See if you can find an elegant way to do this?
#-----------------------------------------------------------------------------

str(flights)
#find weekdays. need to convert date first.
flights$FL_DATE <- as.POSIXct(flights$FL_DATE, format = "%m/%d/%Y")
flights$Weekday <- factor(weekdays(flights$FL_DATE))

ggplot(flights)

library(ggplot2)

##get 

#for JFK 
ggplot(flights[which(flights$DEST == "JFK" | flights$ORIGIN == "JFK"),], 
       aes(DEP_DELAY, color = Weekday)) +  
  geom_histogram(aes(fill = Weekday)) +
  facet_wrap(~Weekday)

#improvements: