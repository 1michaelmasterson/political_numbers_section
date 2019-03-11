#r
########################################
#
# Section 02, PS 218, Spring 2019
#
########################################
#First lets use the project menu in the upper right
#to create an R project




#consul vs script

#you can run
2+2 #  from here by hitting control+enter on this line (command+enter on Mac)

#Importance for replicability
##R proj is good for this too





#This tells you your current working directory
getwd()



#This shows you what is in your environment
#right not there should be nothing
ls()


########################################
# Basic R
########################################



# R is a calculator

1 + 1

3 * 2

4^2

pi # neat! I just learned about this

sin(0)

#square root
sqrt(4)



# use parentheses to group some operation

(1 - 4) * 5


#Compare this
4^(1/2)

#With this
4^(1 / 2) # better

#note that spacing does not matter but
#It is better to space out operators
#This makes code more readable
#You want it to be consistent

(3 + 2i) * 4 # if you want to get really intense



# order of operations applies

(4 * 5) + 1
1 + 4 * 5 # but you should still use parentheses for things like this
(4 * 5) + 1



# arithmetic operators: + - * / ^ exp(3) (adding, subtracting...)

# assignment operator: <-

my.object <- 10

my.object


#my.object is now saved in your environment
#lets see that

ls()


# logical operators: ==, !=, >, >=, <, <= (we will come back to this in later lessons)

4 > 2



# Put data into objects

hey <- 1000

# call the object

hey

# use the object in other commands

4 * hey

# overwrite objects

hey <- hey + 1

hey

new <- hey + my.object

new

my.object <- 1


#########################################
#Practice 1
##########################################

#Question 1: what objects are in your environment


#Question 2: what is the value of each object in your environment?


###############################
#Sequences
###############################

# If I want a sequence of every number
# from 1 to 10
1:10

?seq
#I can also do this with the seq command
seq(from = 1, to = 10, by = 1)

#this allows me to count by different intervals
seq(from = 1, to = 10, by = 2)

seq(from = 1, to = 10, by = 0.5)


################################
# Vectors
################################
#remember in Mike's lecture: Let x = [5 4 9 1 7]?
#This is how you would do that in R
#the c here means concatenate, meaning stick these numbers together into one object
x<-c(5, 4, 9, 1, 7)
x

#What is x sub 4?
x[4]

# It is good practice to rely as much on objects as you can, rather than using raw numbers.


#How many elements are in x?
length(x)

#What happens if you add 1 to x?
x+1

#Multiply by 2?
x*2

#what if we add another vector (of the same length)
#to our vector?
z<-c(1,2,3,4,5)

x+z

#Remember in Mike's lecture we calculated the
#sum of x from 1 to n
#here is how to do that in code
sum(x)


#what is the highest value in x?
max(x)

#the lowest?
min(x)

#the mean?
mean(x)


###what if we only want to sum x from 2to 4 (instead of 5)
sum(x[2:4])


############################################
####Practice 2
##########################################

#Question 1
#Use R to find x sub 2 then add 2 to it


#Question 2
#Use R to find the mean of the first 3 values in x



##############################
#Comments
#############################

#In R you can write comments in your code
#This helps you remember what it does when you come back to it later
#It also helps other people who might use your code later.




#Any line that begins with a # is commented out
#you can also use a # in the middle of a line to only comment out that part
# 2+2 this is not run
2 + 2 #the math is run but the words are not


# you can use the short of Ctrl+shift+c (on windows) or command +shift +c (on Mac) to comment out a line
try it here


if you 
highlighlight muliple lines
you can use this shortcut to
comment them all out
try it on these last 5 lines


###########################
#functions
##########################

#A function is something that takes an arguement and returns a
#value.

#you have probably seen the function y=f(x)
#In this funciton, y is a value and x is an arguement

#almost every command in R is a function

#for example, early when we found that mean of x we used the mean() fuction
#In this cause, mean is the fuction, x is the arguement and the mean of the vector
#y is the value that is returned
mean(x)


###Some function take a default argument
#like getwd()
#for these you do not put anthing in the paretheses

getwd()



#others require and argument
#what happens if we run mean() with no arguments?
mean()

# In R if you want to know how a funciton works
# you can type ?function_name

#for example:
?mean

###############################
#Practice 3
#########################################
# Question 1
#find out what the function
#names() does

# Question2
#what arguments does it take

# We will learn more about this function next week

