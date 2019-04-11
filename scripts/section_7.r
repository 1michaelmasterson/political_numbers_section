#Section 7 Rscript
#data cleaning with case_when
# join
#Transpose
#gather

##############################
#Library Packages
##############################
library(tidyverse)
library(here)
library(broom)
##############################
#Fixing missing values in dataframes
##############################


###Load 2 dataframes to join

#Polity is a dataset that contains regime data at the 
#country-year unit of analysis
polity.data <- read_csv(here("data", "p4v2017.csv"))
spec(polity.data)

#We care about the variables ccode that indicates which country
#country which labels the country in characters
#Year that indicates which year
#and polity that ranks countries form
# -10 to 10 on how democratic they are
#lets simplify to just those variables
polity.data <- select(polity.data, ccode, country, year, polity)

#examine data
polity.data

#summarize data
summary(polity.data)
# min of polity is -88
# uh oh, pollity should never be < -10

#are there other problem values?
polity.data %>% 
  distinct(polity) %>% #distinct is the same as unique but works with tidyverse
  arrange(polity)

#yes there is also -77

# we need to get rid of missing values and
#what if we also want to change polity
#into a variable that indicates
#whether or not a country is a democracy
# and say countries with 6 and above are democracies
#case_when takes a series of fomulas
#where the left had side is a logical test
#and the right hand side is the value to return
polity.data <- mutate(polity.data,
                      #first just fix polity
                      polity = case_when(
                        #you cannot just use NA for case_when
                        #it must match the datatype of the rest of the values
                        polity < -10 ~ NA_real_,
                        TRUE ~ polity),
                      #you can have more than 2 cases
                      demo  = case_when(
                        polity > 5 ~ 1, 
                        polity < 6 ~ 0,
                        TRUE ~ NA_real_)) #Your las one should be a catchall TRUE

summary(polity.data)



#The second dataframe is country-year level data on military capabilities
nmc.data <-read_csv(here("data", "NMC4.csv"))

#We only care about the variables
#ccode
#year
# and milex which is how much a country
#spent on the military in a year

#lets simplify

nmc.data <- select(nmc.data,
                   ccode, year, milex)


#what Lets look
nmc.data

summary(nmc.data)
#milex should never be negative

#any othe problem values?
nmc.data %>% 
  distinct(milex) %>% #distinct is the same as unique but works with tidyverse
  arrange(milex) 

#fix it the same way with mutate and case_when
nmc.data <- mutate(nmc.data,
                  milex = case_when(milex < 0 ~ NA_real_,
                                    TRUE ~ milex))

#its okay now
summary(nmc.data)

##############################
#inner_join Dataframes
##############################
#To join Dataframes they must be at the same unit of analysis
#The variables that label unique rows need to have the same name

# both polity and nmc are at the country-year level
#and have variables labeled ccode and year
#what if the variable was named differently? 
#we can rename it like this

polity.data <- rename(polity.data, year = year)

#to join them we use the inner_join function
#inner_join takes as arguements the dataframes you want to join
# then a by argument that is the names of the variable or variables
#you are joining by in text. If there is more than 1,
#they must be concatenated 

joined.data <- inner_join(polity.data, nmc.data, by = c("ccode", "year"))
joined.data

#lets see it




#cool!

#inner_join will only include rows 
#that contain data from each table


#even though polity starts in 1800
#NMC does not start until 1816, so that
#is where our joined dataset starts
summary(joined.data)


##############################
#Practice 1 (lm review)
##############################

# 1. Make a linear model using the joined data with milex as the dv and
#polity as the IV


# 2. Interpret the results (remember sign, size, and significance)


# 3. Make a prediction dataframe from your model results


# 4. (Challenge) add two variables to your prediction dataframe
# one that is the upper bound of the confidence interval on .fitted
# and another that is the lower bound


##############################
#left_joint 
##############################
#1. read in war.csv as a tibble

war.data <- read_csv(here("data", "war.csv"))
war.data



#2. throw away all the variables except ccode, StartYear1, and WarType
war.data <- select(war.data, ccode, StartYear1)


#3. Rename variables as needed
war.data <- rename(war.data, year = StartYear1)

# we need a variable that records a war happened


#BUT are there some years where more than 1 war happened with a single country?
war.data %>% 
  group_by(ccode) %>% 
  count(year) %>% 
  arrange(desc(n))
  
  
#yes so we have to be careful
#This means we need to make a variable
#that sums wars grouped by both ccode and year
# and then put that variable at the level of the original data
#how can we do this?

#First lets just make a war indicator
war.data <- mutate(war.data,
                   war = 1)


#we can groupby multiple variables
war.data <- war.data %>% 
  group_by(ccode, year) %>% 
  # group_by(year) %>% 
  mutate(num_wars = sum(war)) %>% 
  # we can ungroup to get back to the level of the original dataset
  ungroup() %>% 
  print


summary(war.data)


# 4 join this with our NMC data
#but WAIT war data is only 337 rows
# we can use left_join to include all rows from the first dataset
# and only matching rows from the second dataset
warjoin <- left_join(nmc.data, war.data, by = c("ccode", "year"))
warjoin

#lastly we need to recode NA on war and numwars to 0

warjoin <- mutate(warjoin,
                  war = case_when(
                    is.na(war) ~ 0,
                    TRUE ~ war
                  ),
                  num_wars = case_when(
                    is.na(num_wars) ~ 0,
                    TRUE ~ num_wars
                  ))

warjoin
summary(warjoin)



##############################
#Transpose data
##############################

#before we read it in, lets take a look at 
#this mess in excel

#There are no variable names so set col_names to false
#Otherwise the state will be treated as the variable
sideways.data <- read_csv(here("data", "sideways_polls.csv"),
                         col_names = FALSE)
sideways.data


#flip the table!
rightways.data <- t(sideways.data)

rightways.data
class(rightways.data)


#assign first row that contains 
# names variable to an object
my_names <- rightways.data[1, ]


#remove first row
rightways.data<- rightways.data[-1, ] %>%
  #turn into a tibble
  as_tibble() %>% #ignore the waring here
  #set variable names
  set_names(my_names)

rightways.data


#Its still not right! 
#gop and dem are character and not numberic!


#lets fix this and save over it
rightways.data <- rightways.data %>% 
  mutate(gop = as.numeric(gop),
         dem = as.numeric(dem)) 


#its ready!
rightways.data

##############################
#Pratice 2
##############################

# start with the county.csv file and make it
#a usable tibble in r

#1. First  read it in (be careful not to read the first row as variable names)
#and save it as an r object


#2. Is it facing the right way? If not, fix it


# 3. Make sure your variables have names


# 4. Remove any inappropriate rows


# 5. Convert to a tibble



# 6. Are all of the variables the right class?
# if not, fix them

##############################
#Gather
##############################

#You might come across a dataset like this
#In this case, each year is a seperate column
#It cannot be used as it is
country_wide <- read_csv(here("data", "country_wide.csv"))

country_wide

#Instead we want temp in one variable and year in one variable

#we will use gather
?gather
#this sounds confusing, but lets see it in practice

#move from wide to long
country_long <- country_wide %>%
  gather(key = year, value = avgtemp, -country) 
#we add - country because we want to leave that column alone
#Alternatively, we could have listed all of the columns we did want to gather

#but year cannot contain text
country_long

#This will take out the extra text in our year variable
country_long <- country_long %>% 
  #remove average temp and replace with nothing
  mutate(year = str_replace(year, pattern = "avgtemp.", replace = "")) %>% 
  #make year numeric
  mutate(year = as.numeric(year))


country_long

##############################
#Practice 3
##############################

#take messey wide and make it in long form
#This is a dataset where each row is a poll
# in 1 of 4 counties
#each county was polled both before and after the vote


# 1. read in messy wide.csv to an r object

#2. Convert it from wide format to long format using gather

