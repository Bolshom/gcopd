from math import exp, sqrt
from random import choice, shuffle
from statistics import mean
from time import time

from numpy import arange

from random_descent_optimization import random_descent_optimization


def model(var1, var2):
    return exp(var1 + var2) * var1**2 + var2**3 * (var1+var2)**5


var1_options = [round(num, 2) for num in arange(-5, 5, .02)]
var2_options = [round(num, 2) for num in arange(-5, 5, .05)]

trials = {'random': {'result': [], 'time': []}, 'grid': {'result': [], 'time': []}}

for trial in range(50):

  start = time()

  print('*** START OF RANDOM SEARCH ***')

  optimized = random_descent_optimization(model, var1=var1_options, var2=var2_options)

  end = time()

  print('\n* Elapsed time:', end-start)

  trials['random']['result'].append(optimized['value'])
  trials['random']['time'].append(end-start)

  start = time()

  print('\n*** START OF GRID SEARCH ***')

  all_combinations = [[var1, var2] for var1 in var1_options for var2 in var2_options]
  all_tested_values = [model(combination[0], combination[1]) for combination in all_combinations]

  optimized_tested_value = min(all_tested_values)
  optimized_choice = all_combinations[all_tested_values.index(optimized_tested_value)]

  print('\n* Optimized result:', optimized_tested_value)

  end = time()

  print('\n* Elapsed time:', end-start)

  trials['grid']['result'].append(optimized_tested_value)
  trials['grid']['time'].append(end-start)

print('\nMean time for Random Search:', mean(trials['random']['time']))
print('\nMean time for Grid Search:', mean(trials['grid']['time']))
