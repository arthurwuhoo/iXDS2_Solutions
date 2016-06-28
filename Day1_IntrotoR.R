#----------------------------------------------------------------
# Day 1: Intro to R
#----------------------------------------------------------------
# 1) If x = 1:100 how would you use indexing notation to extract the elements of x which 
# are divisible by 3?
#----------------------------------------------------------------

x <- 1:100
x%%3==0 #x%%3 is the modulo function. i.e. 10 mod 3 = 1 because 1 is the remainder.
        #x%%3==0 is a boolean operation to find the elements of the vector that
        #are mod 0, which means it's perfectly divisible.

x[x%%3==0] #this means that we're indexing the elements of the vector x
           #that are TRUE, thus returning numbers divisible by 3 - 3,6,9, etc.

#----------------------------------------------------------------
# 2) Enter the following data into a vector: 244, 191, 160, 187, 180, NA, 174, 205, 211, 
# 183, NA, 180, 194, 200.

#   Replace the NA values with 0.
#   Print the vector containing the odd numbered observations in two ways:
#     by selecting the odd numbered observations; and
#     by omitting the even numbered observations.
#   Print out the observations which are less than 190.
#----------------------------------------------------------------

vec <- c(244, 191, 160, 187, 180, NA, 174, 205, 211, 183, NA, 180, 194, 200)

## Replace all NA values in the vector with 0
#So the is.na() function will help us return a boolean vector of where the NA values are.

is.na(vec) #as shown, there is an NA value in index 6 and index 11.
vec[is.na(vec)] #this will only return the values at the indices where there is an NA
vec[is.na(vec)] <- 0 #this assigns a 0.


#   Print the vector containing the odd numbered observations in two ways:
#     by selecting the odd numbered observations; and
#     by omitting the even numbered observations.

vec[vec%%2==1] 
vec[!vec%%2==1] #omitting. ! is the negation operator in R

#   Print out the observations which are less than 190.
vec[vec<190]


#----------------------------------------------------------------
# 3) How many rows and columns does the data frame have?
# What class of data is in each column?
# The receptionist accidentally entered the appointment data incorrectly. All of the appointments should occur on the 15th of each month, not the 1st. Update the data to reflect this change.
# How many patients are above the age of 20?
# How many patients have a mass less than 80?
# [Bonus Question] How many patients are female, above the age of 20 and have a mass less than 80?

#----------------------------------------------------------------

patientData <- data.frame(index = 1:13,
                          Age = seq(16, 40, by = 2),
                          Mass = c(63, 68, 73, 76, 82, 83, 91, 86, 82, 78, 73, 68, 63),
                          Gender = c("M", "F", "M", "F", "M", "F", "M", "F", "M", "F", "M", "F", "M"),
                          Appointment = seq(as.Date("2016/01/01"), as.Date("2017/01/01"), by = "month"))

# Display data frame
patientData

# How many rows and columns?
#### Whenever you're checking out a new data frame, use the summary(), str(),
#### and dim() commands to get a great high level overview.

dim(patientData) #13 rows, 5 columns

# What class of data is in each column?
lapply(patientData[,1:5], class)
str(patientData)

# The receptionist accidentally entered the appointment data incorrectly. All of the appointments should occur on the 15th of each month, not the 1st. Update the data to reflect this change.

patientData$Appointment <-seq(as.Date("2016/01/15"), as.Date("2017/01/15"), by = "month")

# How many patients are above the age of 20?
nrow(patientData[patientData$Age<20,]) #2

# How many patients have a mass less than 80?
nrow(patientData[patientData$Mass<80,]) #8

# [Bonus Question] How many patients are female, above the age of 20 and have a mass less than 80?
patientData[which(patientData$Gender=="F" & patientData$Age > 20 & patientData$Mass <80),]
#using which() to kepe track of all my conditionals. which also only likes single ampersands, which is weird.
# 

#----------------------------------------------------------------
# 4)  Using data(USArrests)
# Which state has the lowest murder rate?
data(USArrests) #loads in the dataset to USArrests
str(USArrests) #checking out the structure of the DF and its variable names and values

USArrests[USArrests$Murder == min(USArrests$Murder),] #damn, North Dakota

# Which states have murder rates less than 4.0?
USArrests[USArrests$Murder < 4,]

# Which states are in the top quartile for urban population?
quantile(USArrests$UrbanPop) #returns the 0%, 25%, 50%, 75%, and 100% marks
top.quart <- quantile(USArrests$UrbanPop)[4] #returns the value for the 75% mark
USArrests[USArrests$UrbanPop > top.quart,] 

# [Bonus Question] Subset the data so that you only include the states that are in the top quartile for their urban population. In this new dataset, what is the average murder rate for those states?

newdf <- subset(USArrests, USArrests$UrbanPop > top.quart)
mean(newdf$Murder)

#----------------------------------------------------------------
