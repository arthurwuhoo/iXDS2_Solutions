# -------------------------------------------------------------------------------
# DAY 7 Exercises: Distributions
# -------------------------------------------------------------------------------

# In an agricultural experiment, a large uniform field was planted with a single 
# variety of wheat. The field was divided into many plots (each plot being 200 m in 
# length) and the yield (kg) of grain was measured for each plot. These plot yields 
# followed approximately a normal distribution with mean 40 kg and standard deviation 3
# kg. What percentage of the plot yields were:

# 30 kg or more? ----------------------------------------
1- pnorm(30, mean = 40, sd = 3)

#Between 35 and 40 kg? ----------------------------------
pnorm(40, mean = 40, sd = 3) - pnorm(35, mean = 40, sd = 3)

#Between 40 and 45 kg? ----------------------------------
pnorm(45, mean = 40, sd = 3) - pnorm(40, mean = 40, sd = 3)

#Less than 45 kg? ---------------------------------------
pnorm(45, mean = 40, sd = 3)

# ------------------------------------------------------------------------------
# You're playing a simple game of dice, where success is rolling a 1 or a 2.
# In 20 games, what is the probability exactly 5 successes?

## So just a quick note, the probability of success is 1/3
## For a discrete random variable, dbinom calculates the probability of *exactly*
## N successes happening.

dbinom(5, size = 20, prob = 1/3)

# In 20 games, is the probability of at least 5 successes?

## Using dbinom from before, we could theoretically do this:
#dbinom(5, size = 20, prob = 1/3) + dbinom(6, size = 20, prob = 1/3) +
#  dbinom(7, size = 20, prob = 1/3) + ... + dbinom (20, size = 20, prob = 1/3)

#We can use pbinom to get the CUMULATIVE (i.e. integral) of 5 to 20.
1 - pbinom(4, size = 20, prob = 1/3) #Again, pbinom() is from -infinity to the value specified.

# Can you find a neat way to calculate the probability of between 3 and 6 successes in 20 games?
pbinom(6, size = 20, prob = 1/3) - pbinom (2, size = 20, prob = 1/3)


#Use dbinom() to calculate the probability of 5 successes in 20 games of dice. Can you #find a neat way to calculate the probability of between 3 and 6 successes?
values3to6 <-  lapply(3:6, dbinom, size = 20, prob = 1/3)
values3to6 <- unlist(values3to6)
sum(values3to6)

#doing this without lapply:
dbinom(3, size = 20, prob = 1/3) + dbinom(4, size = 20, prob = 1/3) +
  dbinom(5, size = 20, prob = 1/3) +dbinom(6, size = 20, prob = 1/3)


# ------------------------------------------------------------------------------
# Choose the statistical distribution that best represents each of the following situations, and explain why:
#   Grades in an introductory organic chemistry course.
# NORMAL DIST, would expect for this to follow a normal distribution

# The number of M&Ms of each colour in a pack.
# CHI-SQUARED, two categorical variables

# The chance of drawing a card from the suit of Spades in a standard 52-card deck.
# BINOMIAL, there's a success(25%) and failure(75%) outcome 

# The number of emails received in a given hour during a workday.
# POISSON, we didn't talk about this - this is number of successes expected in a timeframe

# The number of flight passengers at different gates in an airport.
# NORMAL DIST