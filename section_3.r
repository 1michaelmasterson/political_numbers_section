###########################what are packages?
#Packages add functionality on to R



###########################Install packages
#install packages with the install.packages() command
##this command takes the argument of the name of the
#package you want to install in quotes

#this package  helps us take advantage of the features of Rprojects
#to write code that will save and load files
#that will work across different computers
install.packages("here")

#This package contains data
#we will work with
install.packages("gapminder")




###########################Using packages
#Pacakages are not automatically loaded into R to save memory, so
#Even after installing them we need to tell R we want to use it
#with:
#library(package_name)
library(here) # this will spit out your working directory when libraried


library(tidyverse) #we installed this in the first section

#we now have access to the gapminder dataset
library(gapminder)



#############Explore R objects


#What variables are in gapminder?

names(gapminder)

#Lets get the summary statistics of our data
summary(gapminder)



#Lets see the first few rows of our dataframe
head(gapminder)


#what if we just call our dataframe?
gapminder


#how do we refer to a specific variable in our dataframe?
#Use dataframe$variable_name
gapminder$pop

#That is too many!
#what if we just want to know the 15th one?
#variables in dataframes are vectors!
gapminder$pop[15]


# what are all of the countries in our dataframe?
unique(gapminder$country)



###################################################Plots
###What if we want to make a scatter plot of gdp Percapita and life expectancy?


####use ggplot to make plots
##the first arugment is what dataframe we are using
##next arguement, mapping, is what variables we are associating with what axis
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y =lifeExp)) + # we aren't done yet so we need a + here
  #The thing we want to do is add points to our plot
  #We already supply data and mapping above, so we can just use the default arguments
  geom_point()
  


#how can we save this plot?
# use ggsave() which will save the last ggplot to a location you provide
ggsave(here("plots", "first_scatter_plot.pdf"))


#Okay but there is something odd about this plot. All of the points are bunched on the left side
#Why doesn't it look like the plot Mike showed us in class?
#This is because the relationship between gdpPercap and lifeExp is actually logarithmic rather than linear
#this makes sense because once a country is wea=lthy enough to provide good health outcomes
##further wealth does not increase lifeExp much





#plots need labels and a title
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y =lifeExp)) + 
  geom_point() +
  #add a title
  #lable the x axis
  #lable the y axis
  labs(x = "GDP per capita", y = "Life Expectancy (in years)",
     title = "Wealth and Health Outcomes")

#lets save this
ggsave(here("plots", "good_scatter_plot.pdf"))




#what if we want to color code by continents?
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) + 
  geom_point() +
  labs(x = "GDP per capita", y = "Life Expectancy (in years)",
       title = "Wealth and Health Outcomes")


###You can even add a subtitle and a caption
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp, color = continent)) + 
  geom_point() +
  labs(x = "GDP per capita", y = "Life Expectancy (in years)",
       title = "Wealth and Health Outcomes",
       subtitle = "Subtitle goes here",
       caption = "Caption goes here")

#Rather than color code by continents, we could
#also make seperate scatter plots for each
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) + 
  geom_point() +
  #This says  make seperate plots for each continent
  facet_wrap(~ continent) +
  labs(x = "GDP per capita", y = "Life Expectancy (in years)",
       title = "Wealth and Health Outcomes")



############################################
# Practice 1
###########################################
#1. make a scatter plot with lifeExp as the y variable and year as the x variable


#2. give it a good title, x label and y label

#3. save it to your plots folder using code


########################################Histogram

ggplot(data=gapminder, mapping = aes(x = gdpPercap)) +
  geom_histogram()


#lets find better values for the bin widths

#how can we change the number of bins?
ggplot(data=gapminder, mapping = aes(x = gdpPercap)) +
  #bins is an argument specific to histograms so we add it here
  geom_histogram(bins = 15)


#what if we want to customize where the breaks are
ggplot(data=gapminder, mapping = aes(x = gdpPercap)) +
  #breaks is also a histogram specific arguement
  geom_histogram(breaks = seq(from = 0, to =114000, by = 10000))


#give it good labels
ggplot(data=gapminder, mapping = aes(x = gdpPercap)) +
  #breaks is also a histogram specific arguement
  geom_histogram(breaks = seq(from = 0, to =114000, by = 10000)) +
  labs(title = "Global Wealth", x = "GDP per capita",
       y = "Number of Countries")


#change range of the graph
ggplot(data=gapminder, mapping = aes(x = gdpPercap)) +
  #breaks is also a histogram specific arguement
  geom_histogram(breaks = seq(from = 0, to =114000, by = 10000)) +
  ggtitle("Global Wealth") + 
  xlab("GDP per capita") +
  ylab("Number of Countries") +
#This will extend the x axis to 120000 and
  ## raise the  y axis to include up to 1500
  coord_cartesian(xlim = c(0, 120000), ylim = c(0, 1500))


##we can save it the same way
ggsave(here("plots", "histogram.pdf"))

################################################
# Practice 2
###############################################
#1. make a histogram of lifeExp

# 2. Give it a good title as well as x axis and y axis label

# 3.  Save the plot

#####################
# Classes of R objects
####################
##classes of objects
#class tells you what class its arggument is
#nomial/catagorical
#ordinal
#interval
#ratio



class(5)
class("word")
class(TRUE)
###Object class matters for operations
"word" + 2
##This returns an error message b/c you cannot add 2 to a character class object


#notice how the class of each variable is at the top
gapminder
##This is not the same as the level of measurement,
# but you should be able to figure out the level of measurement
# from the class


##what kind of R object is gapminder?
class(gapminder)

#It is a dataframe



###############################################
#Practice 3 (move to end)
###############################################

# 1. What level of measurement is each variable in our dataframe?

# 2. What is the unit/level of analysis of the dataframe?


