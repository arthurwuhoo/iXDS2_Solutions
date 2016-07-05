# -------------------------------------------------------------------------------
# DAY 7 Exercises: Hypothesis Tests
# -------------------------------------------------------------------------------
# 1)
# First, let's explore how the t test confirms some of our core statistical concepts with constructed examples, then we'll move to a real world application.
# Impact of Sample Size on p value / CI in t test.
# Use set.seed(1) so that we all get the same stream of random numbers. Randomly generate two sets of normally distributed random numbers, one with a mean of 0 and one with a mean of 0.05. Repeat this for sample sizes 10, 100, and 10 000. Use the t test to compare the sample mean to the population mean. Report and comment on the differences in p-value and what the confidence interval tells you about the data distributions.

set.seed(1)
a1 <- rnorm(10, mean = 0)
a2 <- rnorm(10, mean = 0.05)
t.test(a1,a2) 
#p value is > 0.05 for the sample estimate of the difference
#CI interpretations: the 95% CI for the mean difference between these two samples
#contains 0, which also indicates that the test leads to an insignificant p-value.

b1 <- rnorm(100, mean = 0)
b2 <- rnorm(100, mean = 0.05)
t.test(b1,b2)

#p value is > 0.05 for the sample estimate of the difference
#CI interpretations: the 95% CI for the mean difference between these two samples
#contains 0, which also indicates that the test leads to an insignificant p-value.


c1 <- rnorm(10000, mean = 0)
c2 <- rnorm(10000, mean = 0.05)
t.test(c1,c2)
#p value is <<<<<< 0.05 for the sample estimate of the difference
#CI interpretations: the 95% CI for the mean difference between these two samples DOES NOT contain 0, which also indicates that the test leads to ansignificant p-value.

# The larger the sample size, the less difference is required between the two samples to 
# prove a statistically significant difference.

#----------------------------
# Impact of difference in mean on p value / CI in t test.
# Randomly generate two sets of normally distributed random numbers, one with a mean of
# 0 and one with a changing mean c(0.01, 0.1, 0.5). For constant sample sizes of 1000, 
# what is the impact on the t test results?

a <- rnorm(1000, mean = 0)
b <- rnorm(1000, mean = 0.01)
c <- rnorm(1000, mean = 0.1)
d <- rnorm(1000, mean = 0.5)

t.test(a, b)
t.test(a, c)
t.test(a, d) #p value gets more significant

#----------------------------
# Impact of standard deviation on p value / CI in t test.
# Finally, explore the impact of changing the standard deviation from 1 to 10 in the 
# low sample size and high sample size cases (low being 10, high being 1000). What do 
# you expect to happen? What actually happens?

low_n_low_sd <- rnorm(10, sd = 1)
low_n_high_sd <- rnorm(10, sd = 10)
t.test(low_n_low_sd, low_n_high_sd) #not significant

high_n_low_sd <- rnorm(1000, sd = 1)
high_n_high_sd <- rnorm(1000, sd = 10) #expect this to not be significant as well,
# because the means are not fundamentally different.

#--------------------------------------------------------------------------------
# 2)
# Let's go back to the USArrests data. One useful application of the t test is to help get an # intuition as to whether splitting a dataset on certain factors (usually discrete) reveals 
# distinct distributions of another factor. You will remember that in this sort of analysis, 
# the factor being split on is the independent variable and the factor being analyzed for its
# distribution is the dependent variable. In this case, try splitting the states by their 
# Urban population. Report the t.test() results on the comparative distributions of murder, 
# assault and rape when you use both a mean splitting point and an upper quartile splitting 
# point. Can you come to any conclusions?
library(dplyr)

high_urb <- USArrests %>% filter(UrbanPop > mean(UrbanPop))
low_urb <- USArrests %>% filter(UrbanPop < mean(UrbanPop))

t.test(high_urb$Murder, low_urb$Murder) #not significant
t.test(high_urb$Assault, low_urb$Assault) #not significant
t.test(high_urb$Rape, low_urb$Rape) #this is significant. the difference between
#Rape rates by more urban / less urban states.


#--------------------------------------------------------------------------------
# 3)
#Look at the B.dk data from the Epi package. Is there a significant difference between the 
# number of males and females born between 1990 and 2009.
install.packages("Epi")
library(Epi)
data(B.dk) # some packages run the data() function automatically, some don't.
head(B.dk)

#this is paired, we want to compare differences within the year.
t.test(B.dk$m, B.dk$f, paired = T) #significant

#--------------------------------------------------------------------------------
# 4)
#A gambler playing Roulette has won on 14 of the 20 occasions that he has bet on Black. Do we
#investigate, offer him a bonus or do nothing? Some time later his luck seems to have changed
#: he has won on 35 of the 100 occasions that he has bet on Black. What do we do now?

#We didn't talk about this in class directly, but this is a proportions test.
#We would investigate or do nothing depending on probability of winning one game in Black.



#--------------------------------------------------------------------------------
# 5)
# Load the MASS package. After doing so, call the "cats" data frame which should now be loaded 
# in the global environment. You're interested in male vs. female cat weight. What test would 
# you run? Then, run that test. What are your interpretations?

# two sample.
library(MASS)
t.test(cats[cats$Sex=="F",2],cats[cats$Sex=="M",2]) #p-value is super low, super significant

# Using the USArrests dataset mentioned earlier, test all of the correlations between murder, 
# assault, and rape. Are they all significant? How would you interpret this?

cor.test(USArrests$Murder, USArrests$Assault)
cor.test(USArrests$Murder, USArrests$Rape)
cor.test(USArrests$Assault, USArrests$Rape)
#Yes, they are all significant.
