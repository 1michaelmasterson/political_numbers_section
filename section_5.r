##############################
#library packages
##############################
library(here)
library(tidyverse)
library(gapminder)




##############################
#read_csv
##############################
#what is a csv?
# comma seperated values

#lets take a look

#variable names must be oneword
#variable names cannot start with a numerica value
#top row MUST be variable names

#by default will open into an excel or excel like program

#commas seperate the columns. Try looking at it in text!

#returns are the rows


#how do we get this into R?

?read_csv

#this reads in the dataset to a dataframe called data
data<-read_csv(here("data", "ex-1_polls_fl-oh-va.csv"))

#will print the class of each column

data






##############################
#Pipes: n_row, count
##############################


#I what to know how many polls were taken in different
#states at different times

data %>% 
  group_by(state_abb) %>% 
  count(poll_end)

#I want to print ALL of them!


data %>% 
  group_by(state_abb) %>% 
  count(poll_end) %>% 
  print(n = 226) # this is not ideal, I had to hard code that

##To find out how many rows are in an object
# use the nrow function
nrow(data)

#lets replace 226 with nrow of whatever is in the pipe
data %>% 
  group_by(state_abb) %>% 
  count(poll_end) %>% 
  print(n = nrow(.)) # Better because dynamic
# if the length of the data changes, this won't break


##############################
#Pipes: filter, count
##############################

#I want to know how many polls in each state
#Obama is ahead

data %>% 
  group_by(state_abb) %>% 
  filter(obama_margin > 0) %>% 
  count()


#helpful BUT I also want to know how many he is behind in
#and how many are tied

#how many behind
data %>% 
  group_by(state_abb) %>% 
  filter(obama_margin < 0) %>% 
  count()

#how many tied
data %>% 
  group_by(state_abb) %>% 
  filter(obama_margin == 0) %>% 
  count()


#What if I want to find the poll
#where obama's lead is the biggest in each state?

data %>% 
  group_by(state_abb) %>% 
  filter(obama_margin == max(obama_margin))

##############################
#Practice 1
##############################

#1. Count how many polls were taken in each state before and after the first debate.
#USE PIPES!


#2. Find the latest poll taken in each state. 
#USE PIPES!


#3 Why did you get more than one poll for each state in Question 2?
#(Use your brain and not R to answer this question)




#############################
#Let's redo Practice 3 from last week with pipes
############################
##############################
#1. Make a dataset grouped by country called country.data


#2. Find out the mean life expectancy by country and
#save this information in a variable called mean_lifeExp in 
#  a dataframe called country.data 

#3. What country has the lowest mean_lifeExp?


#################################

#Remember this was a pain because we needed to keep saving over our data?


#with pipes it is just

gapminder %>% 
  group_by(country) %>% 
  summarize(mean_lifeExp = mean(lifeExp)) %>% 
  arrange(mean_lifeExp) %>% 
  print(n = nrow(.))

#lets take some time to unpack this by only highlighting a row at a time

##############################
#Mutating with pipes
##############################

#what if we wanted to do the same thing we just did except with GDP and
#currently we do not have GDP?

#The mutate command to create it just slides right in

gapminder %>% 
  mutate(gdp = gdpPercap*pop) %>% 
  group_by(country) %>% 
  summarize(gdp = mean(gdp)) %>%
  arrange(gdp) %>% 
  print(n = nrow(.))





##############################
#Practice 2
##############################
#Do problems 6 and 7 from the exercise in a single step using pipes

# 6. We often measure U.S. voting using a political party’s share of the two-party vote: the
# vote percentage for a party when we set aside Independent and third-party voters. We
# would calculate the Democratic share of the two-party vote using the following equation.
# Dem. share of two-party vote =
#   Dem. vote
# (Dem. vote + Rep. vote)
# Create this variable using mutate() and call it dem_2party . 3
# 7. Calculate the mean of Obama’s two-party vote share in each state. 
# • Group the combined data ( polls ) by state, and find the mean in each group. If
# you group_by() the state, calculating the mean with summarize() would give
# you the mean in each group.



##############################
#smooths
##############################
#first, remeber scatter plots

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

#what if we want to plot a line that shows the relationship between
#x and y?
?geom_smooth

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  #adds a line with a 95% confidence interval
  geom_smooth(method = "lm")


#we could also do this with the points if we wish
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  #adds a line with a 95% confidence interval
  geom_smooth(method = "lm") # method argument means linear model. It is important!






#okay but our result is not that good
#When GDP per capita gets really high we are predicting
#outragous life expectancies

#this is because the relationship is not linear
# it is log linear (we will revist this in detail in a future section!)
# lets make the natural log of gdpPercap 

gapminder <- mutate(gapminder,
                    ln_gdpPercap = log(gdpPercap))


#scatter plot first
ggplot(data = gapminder, mapping = aes(x = ln_gdpPercap, y = lifeExp)) +
  geom_point()

#Wow! that looks way better! Lets add the line now.
ggplot(data = gapminder, mapping = aes(x = ln_gdpPercap, y = lifeExp)) +
  geom_point()+
  geom_smooth(method = "lm")

#much more reasonable!


##############################
#Practice 3
##############################

#1. add a variable to gapminder called gdp that measures gdp
##Hint(we did this early we just didn't save it)


#2. Make an appropriately labled plot of this variable that shows both a scatterplot 
# of with gdp as the y variable and pop as the x variable as well as a line with a 95% confidence
#interval that shows the relationship between these variables



#3. save this plot to your figures folder in a file called people_money.pdf


#4. What would be the problem with using this to show a causal relationship between gdp and pop?
##Note: use your brain and not R to answer this question
