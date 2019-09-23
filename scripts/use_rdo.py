from random import choice, shuffle
from time import time

from numpy import arange

from random_descent_optimization import random_descent_optimization


def model(var1, var2, var3):
    return var1**2 + var2**2 * var3**2


var1_options = [round(num, 3) for num in arange(-5, 5, .02)]
var2_options = [round(num, 3) for num in arange(-5, 5, .05)]
var3_options = [round(num, 3) for num in arange(-2, 2, .25)]

tested_values = {}

start = time()

print('*** START OF RANDOM SEARCH ***')

random_descent_optimization(model, var1=var1_options, var2=var2_options, var3=var3_options)

end = time()

print('\n* Elapsed time:', end-start)

start = time()

print('\n*** START OF GRID SEARCH ***')

all_combinations = [[round(var1, 3), round(var2, 3), round(var3, 3)] for var1 in arange(-5, 5, .02) for var2 in arange(-5, 5, .05) for var3 in arange(-2, 2, .25)]
all_tested_values = [model(combination[0], combination[1], combination[2]) for combination in all_combinations]

optimized_tested_value = min(all_tested_values)
optimized_choice = all_combinations[all_tested_values.index(optimized_tested_value)]

print('\n* Optimized result:', optimized_tested_value)

end = time()

print('\n* Elapsed time:', end-start)
