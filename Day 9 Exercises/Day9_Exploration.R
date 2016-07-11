# ----------------------------------------------------
# DAY 10: EXPLORATORY DATA ANALYSIS
# ----------------------------------------------------
# Is there a statistically significant difference between the mass of cars with automatic and manual transmissions in the mtcars data set. What does this mean?

?mtcars #am = 0 if automatic, 1 if manual

automatic <- mtcars %>% filter(am == 0)
manual <- mtcars %>% filter(am == 1)

t.test(automatic$wt, manual$wt, alternative = "greater") #significantly different weights.
#automatic masses are much higher than manual masses

# ----------------------------------------------------
# College ranking feature correlation.
# Find your code that scraped college ranking data from World University Rankings.
# Make sure the data are in a form that can be numerically compared.
# Use the corrplot package to plot the correlation between features.
# Which seem to be the most and least related to their ultimate ranking? Check out the methodology of the ranking system. Does this seem agree with your exploratory analysis?

rankings <- read_html("http://cwur.org/2016.php")
college_df <- rankings %>% html_nodes("table") %>% .[[1]] %>% html_table()

str(college_df) 
college_df[,4:13] <- lapply(college_df[,4:13], as.numeric) #change everything to numeric that should be numeric

install.packages("corrplot")
library(corrplot)

correlation <- cor(college_df[,c(1,4:13)])
corrplot(correlation)

#-------------------------------------------------
# Challenge: Catching Comrades Cheats Grab a subset of race results for the Comrades Marathon. Identify potential cheats. To get some inspiration, read Twins, Tripods and Phantoms at the Comrades Marathon and Comrades Marathon Negative Splits: Cheat Strikes Again. Some things to look for are:
#   Timing Chip mules; and
# suspicious splits.



#This one actually takes forever for the code to run.
#Not covering that here - pasting Andrew's code in later when I get the chance!





#_------------------------------------------------
# Traffic violation visualizations. We're going to take the training wheels off a bit and give you a link
# to a big dataset of Montgomery Country traffic violations.

# You can use their tool on the top right to filter the data based on variables you are interested in 
# analyzing.
# Download or scrape the table so you can load it in R.
# Create summary tables that examine the various columns you have chosen.
# Generate correlation plots and find the most correlated features.
# Create a markdown file that presents this analysis!




