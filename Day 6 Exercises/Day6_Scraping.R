# -------------------------------------------------------------------------------
# DAY 6 Exercises: Scraping Websites
# -------------------------------------------------------------------------------
# 1)
# [30 minutes] Scrape data from http://www.baseball-reference.com/ for the birth dates of Major League baseball players. Does the data support the idea from Gladwell (2008) that most players are born in August?

library(rvest)
birthdays <- read_html("http://www.baseball-reference.com/friv/birthdays.cgi")
birthday_tb <- birthdays %>% html_node(css = "table") %>% html_table()

# -------------------------------------------------------------------------------
# 2)
#[30 minutes] Build a data frame which reflects the relationship between beer consumption and population. You can use the Wikipedia pages for beer consumption and population.

beer <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_beer_consumption_per_capita")
beer_df <- (beer %>% html_nodes(css="table") %>% .[[1]] %>% html_table())

pop <- read_html("https://en.wikipedia.org/wiki/List_of_countries_by_population_(United_Nations)")
pop_df <- (pop %>% html_nodes(css="table") %>% .[[1]] %>% html_table())

#- changing beer_df

beer_df #there are a ton of [N] strings here.
beer_df$Country <- gsub("\\[[[:digit:]]+\\]", "", beer_df$Country)
names(beer_df) <- c("Rank", "Country", "BeerConsumptionperCap", "2013to2014Change", "TotalNationalConsumption", "Year")

#Explaining this grep
#so, the \\[ refers to the first "["
#[[:digit:]] refers to 1 character that is 0-9
# + refers to at least one instance of digit (thus getting the two digit cases)
#\\] gets the right bracket

head(beer_df)


#- changing pop_df
head(pop_df)
names(pop_df) <- c("Rank", "Country", "Continent", "UNRegion", "Pop2016", "Pop2015","change")

pop_df$Country <- gsub("\\[[[:digit:]]+\\]", "", pop_df$Country)
pop_df$Pop2016 <- as.numeric(gsub(",","",pop_df$Pop2016))

#### joining the tables together
merged_df <- dplyr::inner_join(pop_df, beer_df, by = "Country")
merged_df_clean <- na.omit(merged_df)

cor(merged_df_clean$Pop2016, merged_df_clean$TotalNationalConsumption)
#obviously a huge correlation, but bigger countries will obviously drink
#More total beer. what about a per capita basis?

cor(merged_df_clean$Pop2016, merged_df_clean$BeerConsumptionperCap)
# the bigger your country, the less per-capita beer gets drank. unsure
# if this is significant though/

summary(lm(merged_df_clean$Pop2016 ~ merged_df_clean$BeerConsumptionperCap))
#looks like this relationship isnt a significant one.


# -------------------------------------------------------------------------------
# 3)
#[30 minutes] Scrape Eventtiming for the results of the 2015 running of the 25km Stella
# Royal. Store these data in a suitably normalised database.

race <- read_html("http://www.eventtiming.co.za/resultsracecapture.php?link=378")
race_df <- race %>% html_nodes("table") %>% .[[4]] %>% html_table(header = T)
head(race_df)

race_df[grep("Collier", race_df$Surname),] #oooooo
