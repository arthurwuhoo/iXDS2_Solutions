# ---------------------------------------------------------------------------------------
# DAY 3: PACKAGES
# ---------------------------------------------------------------------------------------
## 1) Solutions to #1 is on the google doc -----------------------------------------------


## 2) --------------------------------------------------------------------------------
# [30 minutes] Reading and understanding package documentation: In this exercise you'll be learning 
# about the dplyr package by reading the documentation. We'll be looking more closely at dplyr later
# in the course, so don't worry about mastering this. Use dplyr functionality to do the following 
# with the airlines dataset:

# Use the select() and filter() (only these functions!) to return a data frame that only includes 
#     flights originating or ending in New York City's JFK airport and were delayed.
# Use mutate() to create a new field that reflects the average speed of the plane in flight.

library(readr)
airlines <- read_csv("Airlines Data March 2016.csv")

library(dplyr)
str(airlines)


#testing to see if the following dummy set works with multiple filter statements
des <- c("JFK", "ATL", "LAX", "JFK")
orig <- c("LAX", "JFK", "ATL", "LAX")
id <- 1:4

test <- data.frame(des, orig, id)
test %>% select(des, orig, id) filter(des == "JFK" | orig =="JFK", id == 2 | id == 4)
#in filter, you can add additional filtering arguments by separating with a comma.
#using AND or OR statements in filter() require only one & and |.

str(airlines) #DEST, ORIGIN, and DEP_DELAY are what we need.

### INTRODUCING PIPING SYNTAX - We'll do this in class later but it can be good to understand now.

##CODE BLOCK #1 - no pipes
airlines1 <- airlines
airlines1 <- select(airlines1, DEST, ORIGIN, DEP_DELAY)
airlines1 <- filter(airlines1, DEST == "JFK" | ORIGIN == "JFK", DEP_DELAY > 0)

## CODE BLOCK #2 - pipes
airlines2 <- airlines
airlines2 <- (airlines2 %>% select(DEST, ORIGIN, DEP_DELAY) %>% 
  filter(DEST == "JFK" | ORIGIN == "JFK", DEP_DELAY > 0))

#airlines1 and airlines2 are idential. piping just allows you to more clearly pass values from
#the previous function onto the next function. notice that we no longer have to specify
# "airlines2" in the select or filter statements when we pipe.


## USING MUTATE
str(airlines)
airlines %>% select(DEST, ORIGIN, DEP_DELAY, DISTANCE, AIR_TIME) %>% mutate(mph = DISTANCE/(AIR_TIME/60))
#need to divide AIR_TIME by 60 in order to get hours.
#assume distance is already in miles.
