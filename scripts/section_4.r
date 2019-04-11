#Section 4 Rscript
##############################
#Library packages
##############################
library(gapminder)


library(tidyverse)


##############################
#arguments by number vs. argument by name
##############################
?seq

#You can specify arguments by name as we have been doing

#You can do it without names but they have to be in order!
seq(1, 10, 1)

#is different than 
seq(10, 1, 1)

#Whereas this will work
seq(to = 10, from = 1 , by = 1)



##This will work but you should avoid it
#try to be consistent
seq(1, by = 1, 10)

##############################
#count
##############################
#remember distinct
#will tell you all the
#values a variable takes

distinct(gapminder, continent)

count(gapminder, continent)



#or

count(gapminder, country)




##############################
#select
##############################
# select selects a particular variable

#if we want to do something with year
#we can
select(gapminder, year)

# or

select(gapminder, pop)



#we can use  select to make a smaller version of our dataframe
#that only includes country, year and pop

smaller.dataframe <- select(gapminder, country, year, pop)

#lets see it
smaller.dataframe


####You can also specify a variable you want to exclude with -
#lets make a dataframe without continent

no_continent.data <- select(gapminder, - continent)

#let's see it
no_continent.data

##############################
#arrange
##############################
# arrange puts a dataframe in order
# from greatest to least

# If we want to see the dataset from lowest population to highest  we can
arrange(gapminder, pop)

#If instead we want lowest to highest we can
#add the desc function arround our variable (for descending order)
arrange(gapminder, desc(pop))


#if we want out dataframe to stay in this order
#then we need to save over it
gapminder<-arrange(gapminder, desc(pop))

gapminder

##Discuss: when to write over data
###Only when you are sure what you want to do will work
###Never overwrite the file on your computer the data comes from
###Instead save a new file of the transformed data and hang on to the script you
###Used to transform it


##############################
#Mutate
##############################
#We can create a new variable with the mutate command
#and then save the dataset over our data that includes the
#new variable using <-

#If we want to make a gdp variable my multiplying
#gdp per capita by population we can

#the syntax for mutate is
#the first argument is the dataframe
#the second argument is the name of your new variable = (some function [in our case gdpPercap*pop])
#remember to save the new dataframe over itself with <- or your new variable will not be saved!

gapminder<-mutate(gapminder,
                  gdp = gdpPercap*pop
                  )

#lets see if it is there
gapminder

###what about if I want a log GDP per capita varaible?

gapminder<-mutate(gapminder,
                  ln_gdpPercap = log(gdpPercap))

#lets see it
gapminder

##############################
#Practice 1
##############################

#1: add a new variable to the gapminder dataset that is the
#log of population. Do not forget to save the new version
#of the gapminder dataset that includes the variable over the old version!

# 2: create a new dataset called new.data
#  that includes all of the variables so far
# except pop

# 3 Put new.data in order from highest ln_gdpPercap
#to lowest and save it in that order


##############################
#filter
##############################
#Earlier we used  select to select particular variables (or columns)
#what if we want to select particular observations (or rows) instead?
#use filter



#The syntax for filter is
#first argument is the dataframe
#second argument is a condition based on the data


#for example, what if we only want to look at observations in the year 2002?
filter(gapminder, year == 2002) # the == is important here. It tells R this is a logical condition that
#the variable on the left but take the value on the right

#if we want to save this as a new dataset, we can
year_2002.data <- filter(gapminder, year == 2002)
year_2002.data


#You can use other logical conditions as well
#what if we only want observations after 2002?
filter(gapminder, year > 2002)


#before 2002
filter(gapminder, year < 2002)


#After and including 2002
filter(gapminder, year >= 2002)

#all the years except 2002
filter(gapminder, year != 2002) # != means not equal

#With catagorical data
filter(gapminder, country == "Kuwait")

##############################
#Practice 2
##############################
#1. create a new dataframe called healthy.data that
#includes only observations from gapminder where
#lifeExp is greater than its median


# 2. Find out how many times each continent appears in this dataframe


##############################
#summarize
##############################

#remember how we can use
#summary(dataframe) to get summary stats for every variable?
summary(gapminder)

#what if we only care about 1 varaible?
#we can use the summarize command
#arguments are dataframe, new_variable_name = summary function
summarize(gapminder, mean(pop))


#we could get other values too like the median
summarize(gapminder, median(pop))

#or the standard deviation
summarize(gapminder, sd(pop))


##We can combine these and provide variable names
#to get a summary dataframe

sum.data<-summarise(gapminder,
                    mean_pop = mean(pop),
                    median_pop = median(pop),
                    sd_pop = sd(pop))
sum.data


##############################
#group_by
##############################
#The summarize command by itself might not be that impressive but
#combined with group_by we can use it to find out
#information that we could not otherwise get!


#what if I want to know the mean GDP percapita of all
# of the continents? 
#summary cannot tell us that


#first lets make a new dataset that is grouped by
#continents

continents.data <- group_by(gapminder, continent)

#lets look
continents.data

#now if we call summarize, it will behave differently
summarize(continents.data, mean(gdpPercap))
#It gives us the mean of gdp per cap by continents!


#we could also save this as a new dataframe
##In this case, we should specify the new variable name like we would with mutate
summary.data <- summarize(continents.data, mean_gdPpercap = mean(gdpPercap))
summary.data

##############################
#Practice 3
##############################
#1. Make a dataset grouped by country called country.data


#2. Find out the mean life expectancy by country and
#save this information in a variable called mean_lifeExp in 
#  a dataframe called country.data 

#3. What country has the lowest mean_lifeExp?

#4. Using the gapminder data, Make an appropriately labled histogram of ln_gdpPercap
##save it using ggsave



