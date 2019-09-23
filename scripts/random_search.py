from random import choice, shuffle
from time import time

from numpy import arange

from model import model


var1_options = [round(num, 3) for num in arange(-5, 5, .02)]
var2_options = [round(num, 3) for num in arange(-5, 5, .05)]

tested_values = {}

start = time()

print('*** START OF RANDOM SEARCH ***')

# First Round:
fixed_choice = {'var1': choice(var1_options), 'var2': choice(var2_options)}
fixed_tested_value = model(fixed_choice.values())
tested_values['-'.join([str(num) for num in fixed_choice.values()])] = fixed_tested_value

optimized = False

while not optimized:
  before_random_columns = fixed_tested_value
  #print('\n[]Before random columns model value:', fixed_tested_value)
  #print('Choices:', fixed_choice, '\n')
  random_columns = list(fixed_choice.keys())
  shuffle(random_columns)
  for column in random_columns:
    fixed_variable_index = locals()[column+'_options'].index(fixed_choice[column])
    if fixed_variable_index == 0:
      changes = [1]
    elif fixed_variable_index == len(locals()[column+'_options'])-1:
      changes = [-1]
    else:
      changes = [-1, 1]
    for change in changes:
      temp_choice = {key: value for (key, value) in fixed_choice.items()}
      temp_choice[column] = locals()[column+'_options'][fixed_variable_index+change]
      if '-'.join([str(num) for num in temp_choice.values()]) not in tested_values.keys():
        temp_tested_value = model(temp_choice.values())
        tested_values['-'.join([str(num) for num in temp_choice.values()])] = temp_tested_value
      else:
        temp_tested_value = tested_values['-'.join([str(num) for num in temp_choice.values()])]
      #print('On change loop for {}:'.format(column), temp_tested_value)
      #print('Choices:', temp_choice)
      if temp_tested_value < fixed_tested_value:
        fixed_choice = {key: value for (key, value) in temp_choice.items()}
        fixed_tested_value = temp_tested_value
        break
  #print('\n[]After random columns model value:', fixed_choice)
  #print('Choices:', fixed_tested_value, '\n')
  if fixed_tested_value == before_random_columns:
    optimized = True

optimized_choice = fixed_choice
optimized_tested_value = fixed_tested_value
print('\nFinal Value:\n*', optimized_tested_value)

end = time()

print('\n* Elapsed time:', end-start)

start = time()

print('\n*** START OF GRID SEARCH ***')

all_combinations = [[round(var1, 3), round(var2, 3)] for var1 in arange(-5, 5, .02) for var2 in arange(-5, 5, .05)]
all_tested_values = [model(combination) for combination in all_combinations]

optimized_tested_value = min(all_tested_values)
optimized_choice = all_combinations[all_tested_values.index(optimized_tested_value)]

print('\nFinal Value:\n*', optimized_tested_value)

end = time()

print('\n* Elapsed time:', end-start)
