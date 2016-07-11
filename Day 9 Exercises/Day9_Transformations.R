# ----------------------------------------------------
# DAY 9: TRANSFORMATIONS
# ----------------------------------------------------

# Normalizing, Transforming, and the QQ plot
# Load the ChickWeight dataset from the datasets library. We will be looking at the weight distribution.
# Plot a histogram of weight. What does the shape tell you?
#----

hist(ChickWeight$weight) #skewed but somewhat normal

# Scale the data using scale(). How does the plot of the histogram change?
#----
hist(scale(ChickWeight$weight)) #changes the x-axis to the z-score

# Use qqnorm() and qqline() to create quantile-quantile plots of the scaled and unscaled data. Are they different? Do you understand why?
#----
par(mfrow=c(1,2))
qqnorm(ChickWeight$weight)
qqline(ChickWeight$weight)

qqnorm(scale(ChickWeight$weight))
qqline(scale(ChickWeight$weight))

#They aren't different.
#Scaling it doesnt change the underlying distribution. It just
#literally scales it down to a unitless state

# Try using transform() to add variables that are the log and sqrt of weight. 
# What do you see in the quantile-quantile plots of these variables?
#----

library(dplyr)
ChickWeight <- transform(ChickWeight, sqrt_weight = sqrt(weight))
ChickWeight <- transform(ChickWeight, log_weight = log(weight))

par(mfrow=c(2,2))
dev.off()
qqnorm(ChickWeight$weight)
qqline(ChickWeight$weight)
qqnorm(ChickWeight$log_weight)
qqline(ChickWeight$log_weight)
qqnorm(ChickWeight$sqrt_weight)
qqline(ChickWeight$sqrt_weight)

# Now try using a Box-Cox transform on weight. Compare the results to those from
# the log and sqrt transformations.
#----
library(caret)
(boxcox = BoxCoxTrans(ChickWeight$weight, fudge = 0.05))

ChickWeight$boxcox = predict(boxcox, ChickWeight$weight)
qqnorm(ChickWeight$boxcox)
qqline(ChickWeight$boxcox)

##SQRT still seems to work better.

# -------------------------------------------------------------
# 2)
# Let's do an experiment to help us understand distributions and how 
# understanding their shape helps us inform our transformations.
# Generate 1000 random numbers from the normal distribution with mean = 0 and 
# sd = 0.5. Make a quantile-quantile plot.
# -------

dist_1 <- rnorm(1000, mean = 0, sd = 0.5)
qqnorm(dist_1)
qqline(dist_1)

# Generate 1000 random numbers from the exponential distribution with lambda = 
# 10. Make a quantile-quantile plot.
# -------

?rexp
dev.off()
dist_2 <- rexp(1000 , rate = 10)
qqnorm(dist_2)
qqline(dist_2)

# Take the log of the exponentially distributed numbers. Make a quantile
# -quantile plot.
# -------

dist_2_log <- log10(dist_2)
qqnorm(dist_2_log)
qqline(dist_2_log)

# Bringing it all together. Scrape the mortality rate data. Examine the 
# distribution of the mortality rate by country (histograms and quantile
# -quantile plots should help). Use a transformation to normalize the data if 
# necessary.
# -------
library(rvest)
mortality <- read_html("https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_mortality_rate")
mortality <- mortality %>% html_nodes(css = "table") %>% .[[1]] %>% html_table(header = T, fill = TRUE)

names(mortality) <- mortality[1,]
trimmed <- mortality[-1,]
trimmed[,2:5] <- as.data.frame(lapply(trimmed[,2:5], as.numeric))

str(trimmed) #let's only use the CIA WORLD FACTBOOK data
trimmed <- trimmed[,c(1,4,5)]
names(trimmed) <- c("Country", "Rate", "Rank")

dev.off()
par(mfrow=c(1,2))
qqnorm(trimmed$Rate)
qqline(trimmed$Rate)
#hist(trimmed$Rate)

trimmed <- na.omit(trimmed)
boxcox_mort = BoxCoxTrans(trimmed$Rate, fudge = 0.05)
trimmed$Rate_normalized <- predict(boxcox_mort, trimmed$Rate)
qqnorm(trimmed$Rate_normalized)
qqline(trimmed$Rate_normalized) #looks a bit better / closer alignment to qqline

