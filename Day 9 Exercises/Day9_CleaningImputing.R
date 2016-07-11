# ----------------------------------------------------
# DAY 9: CLEANING, IMPUTING
# ----------------------------------------------------
# 1)
# Fix the missing values in the airquality data.

airquality

find_nas <- lapply(airquality,is.na)
sum_nas <- lapply(find_nas,sum)
sum_nas #Looks like there are 37 missing values in Ozone, and 7 missing values in Solar

#Two ways to handle missing values are to remove the rows, replace them with 0, or
#replace them with the mean.

dim(airquality) #shows that there are 153 total observations. for ozone,
# it could be too destructive to remove 37 rows, so let's replace them with the average.
# Replacing missing values with the average could be considered so long as there aren't
# a crazy number of outliers

hist(airquality$Ozone) #looks a little skewed. we could use the median term too if we wanted

airquality$Ozone[is.na(airquality$Ozone)] <- mean(airquality$Ozone, na.rm = T)

#we can do the same with Solar.R
airquality$Solar.R[is.na(airquality$Solar.R)] <- mean(airquality$Solar.R, na.rm = T)

# ----------------------------------------------------
# 2)
# Outliers in iris.

# Identify the observations from iris that are both outliers in Sepa.Length and Sepal.Width. Consider outliers as calculated by scores() with prob = 0.95.
# Which species are they from?
# Get a sense of how far off the mean they are by using summarize() from dplyr.
# Run lof() on iris (you will have to use select() to remove the Species column before running). Compare the results with those from the original outlier computation.

#install.packages("outliers")
library(outliers)

iris
outlierstatus <- scores(iris$Sepal.Length, prob = 0.95)
iris[outlierstatus, ] #seems like most of the outlier species are virginica, some are setosa

library(Rlof)
library(dplyr)
library(reshape2)
library(ggplot2)

lofed <- as.data.frame(iris %>% select(-Species) %>% lof(k = c(3:6)))

lofed.melt <- melt(lofed)
ggplot(lofed.melt, aes(x = value, color = variable)) + geom_histogram(aes(fill = variable)) + facet_wrap(~variable, ncol = 1) 

# choosing value of 1.6 seems to be good here
# There isn't really a prescribed way to choose outliers every time.
# Ideally you choose k-values of a good range until the difference between consecutive
# k's in their histograms is fairly minimal. In this case, 5 vs. 6 are pretty similar,
# and we should look at those two graphs to judge a decent cutoff.

#Here, 1.6 looks to be decent.

lofed[lofed$`4`>1.65, ] #observations23, 42, 63, 107, 110 are outliers.
lof_outlier_index <- rownames(lofed[lofed$`4`>1.65, ]) #getting out the rownames
lof_outlier_index <- as.numeric(lof_outlier_index)

lof_outlier_index
which(outlierstatus) 
#these look pretty different once you incorporate the multidimensional outlier status
#from LOF()

# ----------------------------------------------------
# 3)
# Outliers and missing data in baseball.
# Load the baseball data from the plyr package using data(baseball, package = "plyr").
# Use the VIM package's aggr() function to visualize the missing values across the columns 
# of baseball.
# Use Grubb's Test to find whether the hr column has any outliers. How far above the IQR is 
# the maximum value of hr?


data(baseball, package = "plyr")
library(VIM)

aggr(baseball) # a huge number of missing values in the last two variables.

hist(baseball$hr)
shapiro.test(baseball$hr) #not normally distributed
grubbs.test(baseball$hr) #there exist outliers here

quantile(baseball$hr) #IQR is 25% to 75%, which is 0-7.
# The max is 66 home runs above 7.


