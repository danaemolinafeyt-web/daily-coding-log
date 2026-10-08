my_value = 3+5*(7-2)**2
print(my_value)

# Variables

#If β = 2.5 and θ = 45, write the Python variable assignments and a line that prints β × θ

beta = 2.5
theta = 45
print(beta * theta)

#You have three variables x₁ = 5, x₂ = 12, x₃ = 20. Write the Python code to sum all three and print the result.
'''x_1 = 5
x_2 = 12
x_3 = 20

sum = x_1+x_2+x_3

print(sum)'''

# Declaring a Linear function in python

def f(X):
    return 2* x+1 # The equation that has been given y=2x+1

x_values = [0,1,2,3] # the values we can subs x with

for x in x_values: # our function
    y = f(x) #Our rule. which states that y is equal to what f(x)
    print(y)

import pandas
import matplotlib

# Charting a linear function in python using SymPy

from sympy import *

x = symbols('x')
f = 2*x+1
plot(f) # straigh line

from sympy import * 

x = symbols("x")
f = x**2 +1
plot(f) #parabola

# f(x,y) = 2x +3y - we have two independent variables & one dependent variable (output f(x,y)- we will need to plot on three dimensions. 

# declaring functions with two independent variables in python

from sympy import * 
from sympy.plotting import plot3d

x, y = symbols('x y')
f = 2*x + 3*y
plot3d(f)

# summation (Σ) just means "loop through a sequence of numbers, do something to each one, add them all up."

# Summation psuedo code

'''total = 0
FOR i FROM 1 TO 5:
    toatl = total + (2*i)
RETURN eturn total '''

# Performing a summation  in python

summation = sum(2*i for i in range(1,6)) # range in python excludes the end number, gives you 1,2,3,4,5
print(summation) # i is a placeholder for representing each index value

#TRAP: If math notaion gives you sum i from 1 to n, you write
# range(1, n+1) not range(1, n)

#TRAP: math starts counting at index 1, but python lists start at index 0. 
# So if you are runnig summing over a list x = [1,4,6,2] w/ n=len(x),
# you loop range(o,n) not range (1,n)


x = [1,4,6,2] #Our row of lockers, each holding one number.
n = len(x)

summation = sum(10*x[i] for i in range (0,n))
print (summation)

#Line 1: x - is a row of lockers, each holding a #
# In the math notation, this whole list is what xi refers to "the number in locker i"
x = [1, 4, 6, 2]

# Line 2: len() just counts how many lockers exist (4 of them) so n=4.
# In the math notation, n is the top number on the summation. Tells you where to stop counting.
n = len(x)

# Line 3: summation = sum(10*x[i] for i in range (0, n) three things at once, lets separate them. 
summation = sum(10*x[i] for i in range (0, n) )

print(summation)

# range(0, n) = range(0, 4) generatees the locker number to visit.
# x[i] - for each locker number i, this opens that locker and grabs the value inside. 
# when i=0, x[0]= 1.
# 10*x[i] - multiplies whatver was in the locket by 10
# sum () - adds up all four those results. 

x = [3, 5, 7]

n = len(x)

summation = sum(10*x[i] for i in range (0, n))

print(summation)

# Summations in sympy

from sympy import *

#this does not create numbers, but placeholders labeled i and n
i, n = symbols('i n')

#this builds formula Σ(i=1 to n) 2i, but it does not calculate yet.
#this is sympy being lazy, no calcs just placeholders
summation = Sum(2*i, (i,1,n))

#subs mean substitute, this replacees the palcehold n with an actual #, 5.
up_to_5 = summation.subs(n, 5)

#this is the step that actually runs the code. 
print(up_to_5.doit())

# Number theory
# Order of operations
# Variables
# Functions
# Summations - From "Essential Math for Data Science" by Thomas Nield