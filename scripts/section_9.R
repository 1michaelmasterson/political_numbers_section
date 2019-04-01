##############################
#library packages
##############################
library(tidyverse)
library(here)
library(gapminder)
library(broom)

##############################
#load data
##############################

who.data <- read_csv(here("data", "who_names.csv"))

who.data

##############################
#Dummy variable review
##############################
# dummy variable must be either a 1 or a 0
#Must have a catagory you leave out


###create dummy variable for the US
gapminder <- mutate(gapminder,
                    us = case_when(
                      country == "United States" ~ 1,
                      TRUE ~ 0
                    ))


###Create dummy variable for Europe
gapminder <- mutate(gapminder,
                    europe = case_when(
                      continent == "Europe" ~ 1,
                      TRUE ~ 0
                    ))


##see them
gapminder


####Put gdpPercap on log scale

gapminder <- mutate(gapminder,
  log_gdppercap = log(gdpPercap)
)



#######Can include in linear model like any other variable
model1.ols <-lm(lifeExp ~ log_gdppercap + us + europe, data = gapminder)
tidy(model1.ols)



########who data example
##make dummy for Asia

who.data <- mutate(who.data,
                   americas = case_when(
                     regionname == "Americas" ~ 1,
                     TRUE ~ 0
                   ))


model.who <- lm(life_exp ~ health_workers + americas, data = who.data)
tidy(model.who)


##############################
#Practice 1
##############################
#1. Using gapminder, create a dummy variable for Kuwait

#2. Rerun model1.ols with the addition of this dummy variable

# 3. Interpret the model




##############################
#Interactions
##############################
# what if the effect of one varaible
# depends on the value of another variable?
# In that case, adding them with 
# y = a +b1x1 +b2x2
#will not capture this relationship



#Instead you have to multiply them like this
# y = a + b1x1 + b2x2 + b3(x1*x2)


#This is called an interaction

# Lets try interacting US and GDP in 
# our model of life expectancy

model2.ols <- lm(lifeExp ~ log_gdppercap * us, data = gapminder)
tidy(model2.ols)
#notice that the terms for each variable alone
#are automatically included in the model



#lets do this with our europe variable

model3.ols <- lm(lifeExp ~ log_gdppercap * europe, data = gapminder)
tidy(model3.ols)


###who data example

model.who2 <- lm(life_exp ~ health_workers * americas, data = who.data)
tidy(model.who2)


##############################
#Practice 2
##############################
#Do one of these predictions for the Kuwait dummy variable

# 1. Create a linear model where lifeExp is the dv
# and log_gdpperca, kuwait, and kuwait*log_gdppercap are the IVs

#2. Interpret the model

##############################
#Predictions with interactions
##############################
#It is not easy to directly interpret the 
#coefficents for regressions with interactions
#This makes it especially important
#to plot these variables' predicted effects

#Here is how




#note if there were other variables in the regression
#that were not a part of the interaction
#we would hold them at their mean (median if they are dummy vars)
prediction_us <- mutate(gapminder,
                       us = 1)

##make augmented dataframe
augment_us <-augment(model2.ols, newdata =prediction_us)

augment_us

##calc confidence interval

augment_us <-mutate(augment_us,
  upperbound = .fitted + (1.96 * .se.fit),
  lowerbound = .fitted - (1.96 * .se.fit)
)


prediction_world <- mutate(gapminder,
                           us = 0) 


augment_world <- augment(model2.ols, newdata = prediction_world)

augment_world = mutate(augment_world,
                       upperbound = .fitted + (1.96 * .se.fit),
                       lowerbound = .fitted - (1.96 * .se.fit))

###Graph it
ggplot(data = augment_world, aes(x = log_gdppercap, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound),
              fill = "blue", alpha = 0.3) +
  geom_line(color = "blue") +
#now do it for the US
  geom_ribbon(data = augment_us, aes(ymin = lowerbound, ymax = upperbound),
              fill = "red", alpha = 0.3) +
  geom_line(data = augment_us, aes(y = .fitted), color = "red")




prediction_eu <- mutate(gapminder,
                        europe = 1)

##make augmented dataframe
augment_eu <-augment(model3.ols, newdata =prediction_eu)

augment_eu

##calc confidence interval

augment_eu <-mutate(augment_eu,
                    upperbound = .fitted + (1.96 * .se.fit),
                    lowerbound = .fitted - (1.96 * .se.fit)
)


prediction_noteu <- mutate(gapminder,
                           europe = 0) 


augment_noteu <- augment(model3.ols, newdata = prediction_noteu)

augment_noteu = mutate(augment_noteu,
                       upperbound = .fitted + (1.96 * .se.fit),
                       lowerbound = .fitted - (1.96 * .se.fit))

###Graph it
ggplot(data = augment_noteu, aes(x = log_gdppercap, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound),
              fill = "blue", alpha = 0.3) +
  geom_line(color = "blue") +
  #now do it for the US
  geom_ribbon(data = augment_eu, aes(ymin = lowerbound, ymax = upperbound),
              fill = "red", alpha = 0.3) +
  geom_line(data = augment_eu, aes(y = .fitted), color = "red")



###WHO example
#For americas
predict_americas <-mutate(who.data,
                          americas = 1)

augment_americas <- augment(model.who2, newdata = predict_americas)


augment_americas <- mutate(augment_americas,
                           upperbound = .fitted + (1.96 * .se.fit),
                           lowerbound = .fitted - (1.96 * .se.fit))

#For the rest of the world
predict_not_americas <-mutate(who.data,
                          americas = 0)

augment_not_americas <- augment(model.who2, newdata = predict_not_americas)

augment_not_americas <- mutate(augment_not_americas,
                               upperbound = .fitted + (1.96 * .se.fit),
                               lowerbound = .fitted - (1.96 * .se.fit))


###Graph it
ggplot(data = augment_not_americas, aes(x = health_workers, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound),
              fill = "blue", alpha = 0.3) +
  geom_line(color = "blue") +
  #now do it for the US
  geom_ribbon(data = augment_americas, aes(ymin = lowerbound, ymax = upperbound),
              fill = "red", alpha = 0.3) +
  geom_line(data = augment_americas, aes(y = .fitted), color = "red")


##############################
#Practice 3
##############################
#Do one of these predictions for the Kuwait dummy variable

# 1. create dataframe where kuwait always = 0

# 2. create augmented dataframe using your model from practice 2 and this new dataframe

# 3. calculate confidence interval

# 4. make gpplot for 
# the predicted value of lifeExp
# across values for log_gdppercap
#when the country is NOT kuwait



