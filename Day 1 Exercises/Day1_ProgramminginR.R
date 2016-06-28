#----------------------------------------------------------------
# Day 1: Programming in R
#----------------------------------------------------------------
# 1) Write a function to calculate Body Mass Index (BMI).
#----------------------------------------------------------------

#height in kg, height in m
bmi <- function(height, weight) {
  x <- height/(weight^2)
  return(x)
}

bmi(180/2.2, 1.8) #arthur's bmi (ooo)

#----------------------------------------------------------------
# 2) Implement a function which calculates the area of a parallelogram. 
#Use  default arguments to cater for the special cases of a rhombus, 
#rectangle and #quare. Choose a suitable name for the function.
#----------------------------------------------------------------

parArea <- function(base, height = base) {
  area <- base * height
  return(area)
}

#not going to trifle with all of the angles.
# you could specify it 

#----------------------------------------------------------------
# 3) Write a function which gives an appropriate greeting (in an exotic 
# language of your choice!) based on the time of day. The function should 
# accept a time as an argument but there should be a suitable default value
# You might find #something useful in the lubridate package. Implement a 
# default greeting for #NA or NULL argument.
#----------------------------------------------------------------

install.packages("lubridate")
library(lubridate)

Sys.time() #gets the current date and time in your console

greeting <- function(time = Sys.time()){
  currenthour <- hour(time)
  if(currenthour >= 6 && currenthour <= 12) {
    print("Good Morning!")
  }
  else if (currenthour > 12 && currenthour <= 17) {
    print("Good Afternoon!")
  }
  else if (currenthour > 17 && currenthour <= 19) {
    print("Good Evening!")
  }
  else {print("Good Night!")}
}

greeting()

#----------------------------------------------------------------
# 4) Write a function which will replace missing elements in a vector. You #should be able to specify the fill value. There should be a reasonable #default for the fill value. You function should be able to deal with the #following cases:
#----------------------------------------------------------------

na.fill <- function(x, fill = 0){
  x[is.na(x)] <- fill
  return(x)
}

#----------------------------------------------------------------
# 5) Use the foreach package to convert the song "99 bottles of beer on the wall" 
# to a function. Generalise to any number of any vessels containing any liquid 
# on any surface. What happens if you change %do% to %dopar%? Can you 
# parallelise the function? Exercise inspired by Grolemund and Wickham (2016).
#----------------------------------------------------------------

#didn't experiment with foreach.

beer <- function(x){
  paste(x," bottles of beer on the wall")
}

beer(99:1)

#----------------------------------------------------------------
# 6) Generalise the function circle_perimeter() to calculate the length of the perimeter of
# an ellipse. Call your new function ellipse_perimeter(). You might find the pracma package
# useful.
#----------------------------------------------------------------

ellipse_perimeter <- function(major_axis, eccentricity=1){
  minor_axis <- major_axis * eccentricity
  perimeter <- 2*pi*sqrt((major_axis^2 + minor_axis^2)/2)
  return(perimeter)
}

ellipse_perimeter(5,0.2) #ellipse with major axis of 5 and minor axis of 1
ellipse_perimeter(1) #circle with radius 1

#----------------------------------------------------------------
# 7) Grab this data archive. Without resorting to any tools outside of R, do the following:
# -unpack the archive;
# -read in all of the files; - concatenate the data into a single data frame (How many 
#       records are there in total?);
# -fix up the ID field; and
# -calculate the average age of the people in the data set.
#----------------------------------------------------------------

## UNPACK THE ARCHIVE
getwd()
setwd("~/iXperience/Exercises/people") #make sure you set your working directory to the folder containing all of those downloaded files
files <-  list.files(pattern="*.csv")

## READ ALL THE FILES
df <- do.call(rbind, lapply(files, function(x) read.csv(x, stringsAsFactors = FALSE)))
str(df$ID) #check the structure of the merged data frame

## COUNT THE NUMBER OF ROWS, CHANGE ID
nrow(df) #shows 5000 rows
df$ID <- 1:5000
str(df) #ok, so names are character and DOB is character too. we want that
#in a date format instead.

## FIXING THE DATE VARIABLE
df$DOB_v2 <- as.Date(df$DOB)

## FINDING THE AVERAGE AGE
diffdays <- difftime(Sys.Date(),df$DOB_v2) #creates the difference in days
diffdays <- as.numeric(diffdays) #making the difference vector numeric
mean(diffdays)/365 #converting days to years
