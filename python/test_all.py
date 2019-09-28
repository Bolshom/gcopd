from math import cos, exp, sin, sqrt
from random import choice, shuffle
from statistics import mean
from time import time

from numpy import arange

from genetic_random_descent import genetic_random_descent_optimization
from random_descent_optimization import rdo_jump, random_descent_optimization


def model(var1, var2):
    #return exp(var1 + var2) * var1**2 + var2**3 * (var1+var2)**5
    #return (1-sin(sqrt(var1**2+var2**2)**2))/(1+.001*(var1**2+var2**2))
    return -10/(.005*(var1**2+var2**2)-cos(var1)*cos(var2/sqrt(2))+2)+10


var1_options = [round(num, 2) for num in arange(-5, 5, .02)]
var2_options = [round(num, 2) for num in arange(-5, 5, .05)]

trials = {'random': {'result': [], 'time': []},
    'genetic': {'result': [], 'time': []},
    'grid': {'result': [], 'time': []}}
    
trials_count = 50

for trial in range(trials_count):
    
  start = time()

  print('*** START OF RANDOM SEARCH ***')

  optimized = random_descent_optimization(model, var1=var1_options, var2=var2_options)

  end = time()

  print('\n* Elapsed time:', end-start)

  trials['random']['result'].append(optimized['value'])
  trials['random']['time'].append(end-start)

  start = time()

  print('*** START OF GENETIC RANDOM SEARCH ***')

  optimized = genetic_random_descent_optimization(model, var1=var1_options, var2=var2_options)

  end = time()

  print('\n* Elapsed time:', end-start)

  trials['genetic']['result'].append(optimized['value'])
  trials['genetic']['time'].append(end-start)


  all_combinations = [[var1, var2] for var1 in var1_options for var2 in var2_options]
    
  start = time()

  print('\n*** START OF GRID SEARCH ***')
 
  all_tested_values = [model(combination[0], combination[1]) for combination in all_combinations]

  optimized_tested_value = min(all_tested_values)
  optimized_choice = all_combinations[all_tested_values.index(optimized_tested_value)]

  print('\n* Optimized result:', optimized_tested_value)
  print('\n* Optimized choice:', optimized_choice)

  end = time()

  print('\n* Elapsed time:', end-start)

  trials['grid']['result'].append(optimized_tested_value)
  trials['grid']['time'].append(end-start)

sum_random = 0
sum_genetic = 0
for trial in range(trials_count):
    if trials['random']['result'][trial] == trials['grid']['result'][trial]:
        sum_random += 1
    if trials['genetic']['result'][trial] == trials['grid']['result'][trial]:
        sum_genetic += 1

print('\nCorrect proportion for Random Search:', round(sum_random/trials_count, 2))
print('\nCorrect proportion for Genetic Random Search:', round(sum_genetic/trials_count, 2))
print('\nReal value:', mean(trials['grid']['result']))

print('\nMean time for Random Search:', mean(trials['random']['time']))
print('\nMean time for Genetic Random Search:', mean(trials['genetic']['time']))
print('\nMean time for Grid Search:', mean(trials['grid']['time']))