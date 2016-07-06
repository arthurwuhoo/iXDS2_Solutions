#-----------------------------------------------------------------------------------
#DAY 8 EXERCISES: SCRAPING DATA VIA API
#-----------------------------------------------------------------------------------
# 1) Identify the various data types in the following JSON document:
# Use fromJSON() to parse the contents of this JSON document.

install.packages("jsonlite")
library(jsonlite)

## our sample JSON file has some errors. I personally use the text editor
## Sublime Text for languages outside of R, which actually highlights code errors 
## across different programming languages for me.

##The first error:   "gender": male,
## male has to be surrounded with quotes

##The second error:  "country": "South Africa" 
#needs a comma at the end

jsonfile <- fromJSON("Day8.JSON")
str(jsonfile) #a JSON is really just a series of lists

#-----------------------------------------------------------------------------------
# 2)
#Register for an API key on Quandl. Pull in data for the Bitcoin/USD and Bitcoin/EUR exchange 
#rates. Plot the two time series on the same set of axes.


usd_json_url <- "https://www.quandl.com/api/v3/datasets/BCHARTS/COINBASEUSD.json"
usd_json <- fromJSON(usd_json_url)

eur_json_url <- "https://www.quandl.com/api/v3/datasets/BCHARTS/COINBASEEUR.json"
eur_json <- fromJSON(eur_json_url)

str(usd_json) 
# within the dataset element, there is data and column_names
# we'll need both to construct a dataframe.

##### making the USD df usable

usd_df <- as.data.frame(usd_json$dataset$data, stringsAsFactors = F) #making a dataframe out of the JSON
usd_df_names <- usd_json$dataset$column_names #applying column names from the JSON
names(usd_df) <- usd_df_names

usd_df$Date <- as.POSIXct(usd_df$Date, format = "%Y-%m-%d") #making the date variable
usd_df[,2:8] <- as.data.frame(lapply(usd_df[,2:8], as.numeric)) #converting character variables to numeric

##### doing the same for EURO df

eur_df <- as.data.frame(eur_json$dataset$data, stringsAsFactors = F)
eur_df_names <- eur_json$dataset$column_names
names(eur_df) <- eur_df_names

eur_df$Date <- as.POSIXct(eur_df$Date, format = "%Y-%m-%d")
eur_df[,2:8] <- as.data.frame(lapply(eur_df[,2:8], as.numeric))

dim(eur_df)
dim(usd_df)

#Not part of the exercise, but I want to see bitcoin exchange rates
#closer to the day of the Brexit

library(dplyr)

eur_df_16 <- eur_df %>% filter(Date < as.POSIXct("07-01-2016", format = "%m-%d-%Y")) %>% filter(Date > as.POSIXct("03-01-2016", format = "%m-%d-%Y"))


usd_df_16 <- usd_df %>% filter(Date < as.POSIXct("07-01-2016", format = "%m-%d-%Y")) %>% filter(Date > as.POSIXct("03-01-2016", format = "%m-%d-%Y"))

plot(usd_df_16$Date, usd_df_16$Close, ylim = c(100,900)) #usd line
lines(eur_df_16$Date, eur_df_16$Close, col = "red") #euro line


#-----------------------------------------------------------------
# 3)
# Use the New York Times' Article Search API to find articles published during 2015 # which relate to Cape Town. AND THEN DO WHAT? The New York Times also exposes some # other APIs. These are worth looking.

# whoops - looks like this wasn't fleshed out. 



# ---------------------------------------------------------------
# 4)
# Using rdrop2 write a script to do the following:
#   save data in a .RData file;
# upload the data onto Dropbox; and
# retrieve the sharing URL for that file.


#----------------------------------------------------------------
# EXERCISE 5
#Let's say we're interested in analysing the geographic data for all names and locations of 
#licensed spirit bottlers and producers in the US. We're interested in finding:

#1) Which ZIP code has the most licensed vendors per capita?
#2) Using the Google Maps API, find the states for the top 50 ZIP codes by licensed vendors per capita.

# You're given two datasets: a JSON file representing all of the names and locations of licensed
#spirit bottlers and producers and a CSV file giving US population by ZIP Code.

#Here's a hint on how to find the states (without searching every ZIP code or using a ZIP code to 
#state reference file):
#----------------------------------------------------------------

# Reading in this JSON seemed to be super frustrating. I (Arthur) tried several methods
# across different JSON packages, and settled on using jsonlite because it involved
# the least amount of work.

# IMPORTANT - three R packages use the same two fromJSON and toJSON commands, despite
# uniquely different functionality for each. That's why the "masking" warning happens
# when you load each of those different packages after another.


library(jsonlite)

spirits_df <- fromJSON("Spirits.JSON", simplifyDataFrame = TRUE)
spirits_df #see? a pretty data frame


#let's tackle the first question - the most vendors per capita.
#First, lets find the number of vendors per zipcode. We'll use the aggregation
#functions in dplyr to make this easier.

head(spirits_df)

spirits_df$zipchar <- as.character(spirits_df$ZIP)

library(dplyr)
(count_by_zip <- as.data.frame(spirits_df %>% group_by(zipchar) %>% summarise(count = n()) %>% arrange(desc(count))))

head(count_by_zip)
#this shows that the zip code with the most licensed vendors is 93446
# 93446 corresponds to Paso Robles, CA
# The wiki page for Paso Robles shows the following:

#Located on the Salinas River north of San Luis Obispo, California, the city is known for its hot 
#springs, its abundance of wineries, production of olive oil, almond orchards, and for playing 
#host to the California Mid-State Fair.
# Cool!

#now lets get the population for each zip code and merge it into this dataset.
population <- read.csv("2010-Census-Population-By-Zipcode.csv", stringsAsFactors = FALSE)

#cool, now let's do an inner join on the zip code.

colnames(count_by_zip)
colnames(population)
colnames(population) <- c("zipchar", "population")
population$zipchar <- as.character(population$zipchar)

#our new dataset
zip_vendor_and_pop <- inner_join(count_by_zip, population, by = "zipchar") 

#making the per capita variable
zip_vendor_and_pop$vendorspercap <- zip_vendor_and_pop$count/zip_vendor_and_pop$population

#sorting it from the highest to lowest per capita
zip_vendor_and_pop_sorted <- zip_vendor_and_pop %>% arrange(desc(vendorspercap))

top50 <- zip_vendor_and_pop_sorted[1:50,] #we're done with part 1.


######## FINDING STATES for the top 50.

library(ggmap)
zipdata <- top50$zipchar
zip_list<- geocode(zipdata, output = "more")
str(zip_list) #shows that the states are stored in administrative_area_level_1

top50$state <- zip_list$administrative_area_level_1

table(top50$state) #go California!
