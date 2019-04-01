#Section 8 multiple regression and log-linear regression
##############################
#library packages
##############################
library(here)
library(tidyverse)
library(broom)
library(gapminder)
library(stargazer)

##############################
#load WHO data
##############################
who.data <-read_csv(here("data", "who2009.csv"))


##############################
#rename who data
##############################
who.data <- select(who.data,
                  country, v9,
                  v22,
                  v159, v168,
                  v174,
                  v186,
                  v192,
                  v249,
                  v259,
                  regionname)

who.data <- rename(who.data,
                   life_exp = v9,
                   infant_mort = v22,
                   health_workers = v159,
                   hosp_beds = v168,
                   health_spend = v174,
                   private_spend = v186,
                   percap_spend = v192,
                   tfr = v249,
                   gnp_percap = v259
                   )

who.data
##############################
#Make GDP variable in gapminder
##############################
#this should be familiar to you now

gapminder <- mutate(gapminder,
  gdp = pop*gdpPercap
)


##############################
#Multiple Regression
##############################

#Regression "controlling for" other factors


#need it b/c omitted variable bias


# y = a + b1x1 + b2x2 +b3x3 + ... + e
# b1 is the effect of x1 all else constant
#a is predicted value of y when all x vars are 0


model.ols1 <- lm(lifeExp ~ gdp + pop, data = gapminder)
tidy(model.ols1)
stargazer(model.ols1, type = "text")
#The effects are too small to see
#we need to rescale

who.ols1 <- lm(life_exp ~ health_workers + hosp_beds + gnp_percap, data = who.data)
tidy(who.ols1)
stargazer(who.ols1, type = "text")


##############################
#Log Linear Regression
##############################
# make log of pop and gdp
gapminder <-mutate(gapminder,
                   log_pop = log(pop),
                   log_gdp = log(gdp))


model.ols2 <-lm(lifeExp ~ log_gdp + log_pop, data = gapminder)
tidy(model.ols2)
stargazer(model.ols2, type = "text")


##############################
#Practice 1
##############################
#1. Which variable in who.ols1 might it be better to log?


# 2 Use mutate to add a logged version of that variable to who.data

# 3. rerun the results of who.ols1 with the new variable


#4. Interpret the results

##############################
#Multiple Prediction
##############################

###We want to see the effect of log_GDP holding log population constant!
##We should hold population at its mean

#To do multivate predictions we need to create a new dataframe
#where the values of our variable are what we want to predict with


#first make a dataframe prediction dataframe from original data
#note you MUST include the DV in the prediction data
#the easiest way is just to copy everything
prediction.data <-gapminder

#now set log pop to its mean for every row
prediction.data <-mutate(prediction.data,
                         log_pop = mean(log_pop))


###Now we can use augment to predict
#using our new precition data!
model2.predict <-augment(model.ols2, newdata = prediction.data)
model2.predict


####we should calculate our confidence interval
#exactly as before

model2.predict <- mutate(model2.predict,
                         upperbound = .fitted + (.se.fit * 1.96),
                         lowerbound = .fitted - (.se.fit * 1.96))


#lets make a graph of our predictions
ggplot(data = model2.predict, aes(x = log_gdp, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound), alpha = 0.4) +
  geom_line() +
labs(x = "Log GDP", y = "Life Expectancy in Years",
     title = "Health and Wealth")
  
##But we can do even better
#log gdp is difficult to interpret
#we can rescale the x axis

#lets recreate
#gdp
#then make it in billions
model2.predict <-mutate(model2.predict,
                          gdp = exp(log_gdp),
                        gdp_billions = gdp/1000000000)



ggplot(data = model2.predict, aes(x = gdp_billions, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound), alpha = 0.4) +
  geom_line() +
  labs(x = "GDP (in Billions)", y = "Life Expectancy in Years",
     title = "Health and Wealth") 

##############################
#Practice 2
##############################
# Use who.ols1 to predict the effect of health workers on life_exp
# while holding hosp_beds and gnp_percap at their means

#1. Create new dataframe from who.data called who_predict.data

who_predict.data <- who.data

#2. Set hosp_beds and gnp_percap at their means in who_predict.data
##HINT you must use , na.rm = TRUE  when calcuating the means of these variables

who_predict.data <- mutate(who_predict.data,
                           hosp_beds = mean(hosp_beds, na.rm = TRUE),
                           gnp_percap = mean(gnp_percap, na.rm = TRUE))

#3. Make prediction frame using who.ols1 and who_predict.data
predict.data.practice <- augment(who.ols1, newdata = who_predict.data)

predict.data.practice

##############################
#US dummy
##############################
#How are we doing for the US?

ggplot(data = model2.predict, aes(x = gdp_billions, y = .fitted)) +
  geom_line(aes(y = .fitted)) +
geom_point(data = filter(model2.predict, country == "United States"),
           aes(y =lifeExp)) +
  labs(x = "GDP (in Billions)", y = "Life Expectancy in Years",
       title = "Health and Wealth") 

#Not so well
  #lets make a dummy for the us
gapminder <-mutate(gapminder,
                   us = case_when(
                     country == "United States" ~ 1,
                     TRUE ~ 0
                   ))

#how often is it us?
count(gapminder, us)




#lets control for the US in our model

model.ols3 <- lm(lifeExp ~ log_gdp + log_pop + us, data = gapminder)
tidy(model.ols3)

#predict it again!
prediction2.data <-gapminder


#just like before we need to hold log_pop at its mean
#how do we do this for the US which is either 1 or 0
summarize(gapminder, mean(us))
#you cannot be 0.007 us
#Use the median for dummy variables!
summarize(gapminder, median(us))


#####Predict results for not the us
prediction.world <-mutate(prediction2.data,
  log_pop = mean(log_pop),
  # us = median(us)
  us = 0
)

model3.predict_world <-augment(model.ols3, newdata = prediction.world)

model3.predict_world <- mutate(model3.predict_world,
                         upperbound = .fitted + (.se.fit * 1.96),
                         lowerbound = .fitted - (.se.fit * 1.96))



#####Predict results for  us
prediction.us <-mutate(prediction2.data,
                          log_pop = mean(log_pop),
                          # us = median(us)
                          us = 1
)

model3.predict_us <-augment(model.ols3, newdata = prediction.us)
# model3.predict_usad <-add_predictions(model.ols3, data = prediction.us)

model3.predict_us <- mutate(model3.predict_us,
                               upperbound = .fitted + (.se.fit * 1.96),
                               lowerbound = .fitted - (.se.fit * 1.96))



#lets make a graph of our predictions

##Rescale

model3.predict_world <-mutate(model3.predict_world,
                        gdp = exp(log_gdp),
                        gdp_billions = gdp/1000000000)


model3.predict_us <-mutate(model3.predict_us,
                              gdp = exp(log_gdp),
                              gdp_billions = gdp/1000000000)



ggplot(data = model3.predict_world, aes(x = log_gdp, y = .fitted)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound), alpha = 0.4, color = "blue") +
  geom_line(color = "blue") +
  geom_line(data = model3.predict_us, aes(y = .fitted), color = "red") +
  geom_ribbon(data = model3.predict_us, aes(ymin = lowerbound, ymax = upperbound),
              alpha = 0.4, color = "red") +
  labs(x = "GDP (in Billions)", y = "Life Expectancy in Years",
       title = "Health and Wealth") 



ggplot(data = model3.predict_world, aes(x = gdp_billions, y = .fitted)) +
  # geom_point(data = filter(model2.predict, country == "United States"),
  #            aes(y =lifeExp)) +
  geom_ribbon(aes(ymin = lowerbound, ymax = upperbound), alpha = 0.4, color = "blue") +
  geom_line(color = "blue") +
  geom_line(data = model3.predict_us, aes(y = .fitted), color = "red") +
  geom_ribbon(data = model3.predict_us, aes(ymin = lowerbound, ymax = upperbound),
              alpha = 0.4, color = "red") +
  labs(x = "GDP (in Billions)", y = "Life Expectancy in Years",
       title = "Health and Wealth") 


##############################
#Practice 3
##############################
# 1. Add a dummy variable for the Americas region to
#the who.data dataset


#2. recreate the linear model from who.ols1 with this variable as an additional control


#3. Interpret the results of your new model
