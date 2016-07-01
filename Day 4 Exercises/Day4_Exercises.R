#----------------------------------------------------------
# DAY 4 Exercises: Working with Text
#----------------------------------------------------------
# 1)
# String concatenation Download the 8 text files named "1.txt", "2.txt". "8.txt". Without 
# writing out all of the text file paths yourself, use list.files() command to easily read in
#all of the text and concatenate it into a single string. Be wary of the lack of spaces or 
#extra spaces that come from concatenation. It should, by the end, read like a proper sentence.

library(stringr)
list.files()
listspeech <- lapply(list.files()[1:8], readr::read_lines)
speech <- unlist(listspeech)
speech <- str_trim(speech)
speech <- str_c(speech, collapse = " ") #still an extra comma in there but you get the idea

#----------------------------------------------------------
# 2)
#Create regular expressions that
#match words which begin and end with a consonant (regardless of punctuation) in this text:
#I can't believe that last GoT episode. How crazy was that?

gotstring <- "I can't believe that last GoT episode. How crazy was that?"

str_extract_all(gotstring,"\\b[A-Za-z&&[^AaEeIiOoUu]][:alpha:]*[A-Za-z&&[^AaEeIiOoUu]]\\b")

#\\b marks the beginning and end of a word
#\\  [A-Za-z&&[^AaEeIiOoUu]] a consonant (reads as any letter between A-Z that's not a vowel, i.e. a consonant)
#\\ [:alpha:]+ specifies any letter after the first consonant
#\\ [A-Za-z&&[^AaEeIiOoUu]]\\b a consonant that ends the word

#match words which end with "ng"", but not with"ing" in this text:
#Hope. It is the only thing stronger than fear. A little hope is effective. A lot of hope #is dangerous. A spark is fine, as long as it's contained.

hope <- "Hope. It is the only thing stronger than fear. A little hope is effective. A lot of hope is dangerous. A spark is fine, as long as it's contained."
str_extract_all(hope,"[[:alpha:]]+[^i]ng\\b") #sounds good

#match valid email addresses from a .com domain (example@example.com would return TRUE, but #example@yahoo.org would return FALSE). Use the following test addresses:

email <- c("patrick@yahoo.com","jeff@gmail.com","yash@something.net", "melonda@something.net")
str_extract_all(email,"\\b[[:alnum:]]+@[[:alnum:]]+.com\\b")

#----------------------------------------------------------
# 3) 
#Most Common Stems (not words) in Obama's State of the Union Find the most frequently #appearing stem in the State of the Union text. Make sure that you do all of the proper #text cleaning, such as setting to lowercase, removing trivial stop words, stemming the #data, etc. as you go through this process.