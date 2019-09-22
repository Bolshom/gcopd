from random import choice

from numpy import arrange


var1_options = arrange(.01, .5, .02)
var2_options = arrange(1, 10, 1)
var3_options = arrange(.5, 1, .1)

tested_values = {}

# First Round:
var1 = choice(var1_options)
var2 = choice(var2_options)
var3 = choice(var3_options)
actual_choice = {'var1': var1, 'var2': var2, 'var3': var3}
actual_tested_value = model(data, var1, var2, var3)
tested_values['-'.join(actual_choice.keys())] = actual_tested_value

optimized = False

while not optimized:
  before_random_columns = actual_tested_value
  random_columns = choice(['var1', 'var2', 'var3'])
  for column in random_columns:
    old_choice = actual_choice
    old_tested_value = actual_tested_value
    actual_variable_index = locals()[column+'_options'].index(locals()[column])
    if actual_variable_index == 0:
      change = 1
    elif actual_variable_index == len(locals()[column+'_options']):
      change = -1
    else:
      change = choice([-1, 1])
    locals()[column] = locals()[column+'_options'][actual_variable_index+change]
    actual_choice = {'var1': var1, 'var2': var2, 'var3': var3}
    if '-'.join(actual_choice.keys()) not in tested_values.keys():
      actual_tested_value = model(data, var1, var2, var3)
    else:
      actual_tested_value = tested_values['-'.join(actual_choice.keys())]
    tested_values['-'.join(actual_choice.keys())] = actual_tested_value
    if actual_tested_value < old_tested_value:
      actual_choice = old_choice
      actual_tested_value = old_tested_value
  if actual_tested_value == before_random_columns:
    optimized = True

optimized_choice = actual_choice
optimized_tested_value = actual_tested_value
  
