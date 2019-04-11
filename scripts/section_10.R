#Section 10  regression output and standardized coefficients

##############################
#Library packages
##############################
library(here)
library(tidyverse)
library(broom)
library(stargazer)
##############################

#Read in data
##############################
who.data <- read_csv(here("data", "who_names.csv"))

##############################
#Model Output with Stargazer
##############################

model.who <- lm(life_exp ~ health_workers + hosp_beds, data = who.data)
tidy(model.who)

##Basic output
stargazer(model.who, type = "text")


##You can fix this up before moving it to a report
stargazer(model.who, type = "text",
          #change IV labels
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)")
          )



stargazer(model.who, type = "text",
          #change IV labels
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)"),
          # change DV label
          dep.var.labels = "Life Expectancy"
)


stargazer(model.who, type = "text",
          #change IV labels
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)"),
          # change DV label
          dep.var.labels = "Life Expectancy",
          # remove excess information
          omit.stat = c("f", "ser")
)


##Sometimes you might want to include a model without controls
model.who_no_controls <- lm(life_exp ~ health_workers, data = who.data)
tidy(model.who_no_controls)


####Put both models side by side for comparison 
stargazer(model.who_no_controls, model.who
          , type = "text",
          #change IV labels
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)"),
          # change DV label
          dep.var.labels = "Life Expectancy",
          # remove excess information
          omit.stat = c("f", "ser")
)


####Put both models side by side for comparison and label them properly
stargazer(model.who_no_controls, model.who
          , type = "text",
          #add text label to each model
          column.labels = c("No Controls", "Controls"),
          #remove model numbers
          model.numbers = FALSE,
          #change IV labels
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)"),
          # change DV label
          dep.var.labels = "Life Expectancy",
          # remove excess information
          omit.stat = c("f", "ser")
)

#when moving it into a document
#need to use appropriate mono-space font

##############################
#Practice 1
##############################

#1. make a linear model where
# the dependent variable is infant_mort
# and the independent variables are health_workers
# and hosp_beds

# 2. Make stargazer table from the model output
# that is fully labeled and presentable.
# Be sure to remove the f-statistic and
# residual standard error

# 3. Move into a document
#using a monospace font

##############################
#Standardize coefficents
##############################
#Coefficents are not always directly comparable 
# because our variables are not always measured on the same
# scale. This means a 1 unit change in 1 variable might be
#very different from a 1 unit change in another variable

# There are a lot of different
# ways to put variables on the same scale
# a common one is to put them on the 
# scale of their standard error.

# Before dividing by the standard error we 
#subtract the mean of the variable
# this is called deeaning



##NOTE: it does not make sense to 
# standardize dummy variables or other kinds of 
# catagorical variables because a 1 standard 
# error change does not make sense
# for these variables

##you can see the standard error of all of your
# variables this way
#remember standard error is the sample version of 
#standard deviation
summarize(who.data,
          #remember to tell r what to do if there is missing data
          se_health_workers = sd(health_workers, na.rm = TRUE),
          se_hosp_beds = sd(hosp_beds, na.rm = TRUE),
          se_life_exp = sd(life_exp, na.rm = TRUE))


#we can quickly see the means this way
summary(select(who.data, health_workers,
               hosp_beds, life_exp))

#Lets do this manually

standard.data <- mutate(who.data,
  health_workers = ((health_workers - mean(health_workers, na.rm = TRUE))/
                      sd(health_workers, na.rm = TRUE)),
  hosp_beds = ((hosp_beds - mean(hosp_beds, na.rm = TRUE))/
                 sd(hosp_beds, na.rm = TRUE)),
  life_exp = ((life_exp - mean(life_exp, na.rm = TRUE))/
                sd(life_exp, na.rm = TRUE))
)

summary(select(standard.data, life_exp, hosp_beds, health_workers))


###make model with this

manual_standard.model <- lm(life_exp ~ health_workers + hosp_beds, data = standard.data)
tidy(manual_standard.model)


##There is an easier way to rescale variables
#using the scale function
standard.data2 <- mutate(who.data,
                        health_workers = scale(health_workers),
                        hosp_beds = scale(hosp_beds),
                        life_exp = scale(life_exp)
)
summary(select(standard.data2, life_exp, health_workers, hosp_beds))



#run standardized 
standard.model <- lm(life_exp ~ health_workers + hosp_beds, data = standard.data2)
tidy(standard.model)

#are they the same?
stargazer(manual_standard.model, standard.model,
          type = "text")
# we did it!

#You can adjust the other stargazer
#options as normal
stargazer(standard.model, type = "text",
          covariate.labels = c("Health Workers (per 10,000 people)",
                               "Hospital Beds (per 10,000 people)"),
          # change DV label
          dep.var.labels = "Life Expectancy",
          # remove excess information
          omit.stat = c("f", "ser"),
          #Add a note explaining the output is standardized
          notes = "Variables demeaned and normalized by standard error."
)





#lets do another example
#modeling hosp_beds ~
# log gnp_percap and log percap_spending

standard_data3 <-mutate(who.data,
                        hosp_beds = scale(hosp_beds),
                        log_gnp_percap = scale(log(gnp_percap)),
                        log_percap_spending = scale(log(percap_spend))
                        )




standard_spending_model <- lm(hosp_beds ~ log_gnp_percap + 
                                log_percap_spending, data = standard_data3)

tidy(standard_spending_model)







##############################
#Practice 2
##############################



#1. Make a new dataframe called
# standard.practice that contains
#standardized versions of the following
#variables: infant_mort, health_workers,
# and hosp_beds using the who.data dataframe

# 2. Make a linear model
#where infant_mort is the DV and
# health_workers and hosp_beds
# are the IVs using your new
# standard.practice dataframe

# 3. Interpret the model

##############################
#Coef plots
##############################
#It is often easier for the reader to see coefficents and confidence intervals
#In a plot than in a table
#Usually when showing coefficents in a plot they
#should be standardized so they are comparable


#You can use tidy to get confidence intervals
#for the coefficents
#Keep in mind this is not the same as using augment
# and calculating the confidence interval for the
# predicted value of y
model.tidy <- tidy(standard.model, conf.int = TRUE)
model.tidy


###makeplot
ggplot(model.tidy, aes(x = term, y = estimate,  color = term)) +
 #This creates a point with a range around it
  #The point is at y = std_estimate and the range
  #is the confidence interval
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
#This flips the plot
    coord_flip() +
  labs(x = "Variable", y = "Standardized Coefficent") +
  scale_x_discrete(labels = c("Health Workers (per 10,000 people)",
                              "Hospital Beds (per 10,000 people)",
                              "Intercept")) +
  #add a horizontal line a zero to make it easier
  #to tell if relationships are significant
  geom_hline(aes(yintercept=0))
  

##Okay but we probably don't care to plot the intercept
#lets say the data is the model.tidy without the first row
ggplot(model.tidy[-1, ], aes(x = term, y = estimate,  color = term)) +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
  coord_flip() +
  labs(x = "Variable", y = "Standardized Coefficent") +
  scale_x_discrete(labels = c("Health Workers (per 10,000 people)",
                              "Hospital Beds (per 10,000 people)")) +
  #add a horizontal line a zero to make it easier
  #to tell if relationships are significant
  geom_hline(aes(yintercept=0)) +
    #Lets also remove the legend because we really don't need it
  theme(legend.position = "none")


##Lets do this for our spening model

spend.tidy <- tidy(standard_spending_model, conf.int = TRUE)


#Notice what is the same and 
#what is different from the previous plot
ggplot(spend.tidy[-1, ], aes(x = term, y = estimate,  color = term)) +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
  coord_flip() +
  labs(x = "Variable", y = "Standardized Coefficent") +
  scale_x_discrete(labels = c("Log GNP (per capita)",
                              "Log Health Spending (per capita)")) +
  #add a horizontal line a zero to make it easier
  #to tell if relationships are significant
  geom_hline(aes(yintercept = 0)) +
  #Lets also remove the legend because we really don't need it
  theme(legend.position = "none")



##############################
#Practice 3
##############################

#. 1. Use tidy to get the 
# coefficents and confidence intervals
# for the regression model
# you created in practice 2

# 2. Create a ggplot that plots
#these coefficents and their confidence intervals
#Make sure not to include the intercept in the plot
#Be sure the plot is properly labled and presentable



