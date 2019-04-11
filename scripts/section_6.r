# Section 6  lm, significance, residuals;

##############################
#library packages
##############################
library(here)
library(tidyverse)
library(gapminder)

#this will let us make cool tables
install.packages("stargazer")
library(stargazer)

#for augment
library(broom) 
#otherwise you need to use broom::augument


library(datasets)
longley

##############################
#Linear Models
##############################
#remember this:
#y = mx + b ?

#when doing a linear model we think it this way, but the intutition is the same

#y = a + bx + error

#y_hat = a + bx




#remember variables can be related by chance,
#this is how we formally test whether or not we think there is a relationship
#if we think the relationship is linear and y measured at the interval level

#lets examine this for gdpPercap and lifeExp

# we do this with the lm function
#you should always save the results to a new object
#the first argument is the dependent variable follwed by a ~
# next comes the independent variable
#the next argument is the data this comes from

model1.ols <- lm(lifeExp ~ gdpPercap, data = gapminder)
#call tidy on the model object to see the result
tidy(model1.ols)

#use stargazer to put it in a good looking table
stargazer(model1.ols, type = 'text')


#what does it mean?


####We need to deflate GNP by dividing it by the deflator
# to make real gnp
longley <-mutate(longley,
                 realgnp = GNP / GNP.deflator)


model2.ols <- lm(Employed ~ realgnp, data = longley)
tidy(model2.ols)
stargazer(model2.ols, type = 'text')



##############################
#Practice 1
##############################

#1 add a variable to the longley dataset that
# measures the proportion of the population that is employed
#called prop_employed

# 2. Make a model that estimates the effect of realgnp on propemployed

#3. interpret the sign, size, and significance of the relationship between gdp and LifeExp
#Note: this step is done by examinging the results from the previous step


##############################
#Residuals
##############################

#lets make a dataset of model 1 output
model1.pred <- augment(model1.ols)

model1.pred

#we are missing some
ggplot(gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(color = "blue") +
  geom_line(data = model1.pred, aes(y = .fitted)) #This makes a line if you supply all the y values


#This looks like a pattern
ggplot(model1.pred, mapping = aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0) #This makes a horizontal line
  



#lets make a dataset of model 2 output
model2.pred <- augment(model2.ols)

model2.pred

#we are missing some
ggplot(longley, mapping = aes(x = realgnp, y = Employed)) +
  geom_point(color = "blue") +
  geom_line(data = model2.pred, aes(y = .fitted)) 


#This looks like more like what we would want
ggplot(model2.pred, mapping = aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0) 


##############################
#Practice 2
##############################

#1. make a model that explains Employed with Population using the longley data

# 2.make a prediction dataframe from this model 
#modelp.pred


# 3. Make a scatterplot of the fitted values and residuals
#add a horizontal line to this plot at y = 0


#4. Interpret this plot. Are we a good fit?

  
##############################
#The concepts and math behind linear models
##############################

##Lets PAUSE to review how the Null hypothesis is tested in our models


###The upper bound of a confidence interval is 
#the fitted value (plus the critical value * standard error)
#The lower bound is the fitted value - (the critical value*standard error)
#In the T distribution, the 95% critical value is approximately 1.96


##Remember we got this from augmenting 
#our model1 output
model1.pred

###Calculate confidence interval


##Calc upperbound

model1.pred <- 
  mutate(model1.pred, 
         upperbound = .fitted + (.se.fit * 1.96))

##Calc lowerbound

model1.pred <- 
  mutate(model1.pred, 
         lowerbound = .fitted - (.se.fit * 1.96))


##what do we have
select(model1.pred, upperbound, .fitted, lowerbound)


#########Predicted values with CI

#just plot the fitted line
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_line(data = model1.pred, aes(y = .fitted)) +
  coord_cartesian(xlim = c(0,  120000), ylim = c(0, 150))


#does this look familiar? it should
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_line(data = model1.pred, aes(y = .fitted)) +
  geom_smooth(method = "lm", se = FALSE, lty = 2) + #se = FALSE means no confidence interval
  # lty =2 makes it a dashed line
  coord_cartesian(xlim = c(0,  120000), ylim = c(0, 150))


#It is the same line!!!
#and the 95% confidence interval matches what we found with upper and lower bound

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_line(data = model1.pred, aes(y = .fitted)) +
  geom_line(data = model1.pred, aes(y = upperbound)) +
  geom_line(data = model1.pred, aes(y = lowerbound)) +
  coord_cartesian(xlim = c(0,  120000), ylim = c(0, 150))


#lets check
ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  geom_line(data = model1.pred, aes(y = .fitted)) +
  geom_line(data = model1.pred, aes(y = upperbound)) +
  geom_line(data = model1.pred, aes(y = lowerbound)) +
  geom_smooth(method = "lm") +
  coord_cartesian(xlim = c(0,  120000), ylim = c(0, 150))

#cool!

##############################
#Practice 3
##############################
#1. Make a model that examines the effect of Armed.Forces on Employed

#2. Make the table look nice with stargazer

#3. Interperate the sign, size and significance of the coefficent of Armed.Forces


# 4. Plot Armed.Forces' effect on Employed with confidence intervals using geom_smooth

