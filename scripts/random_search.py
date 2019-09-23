from random import choice, shuffle

from numpy import arange

from model import model


var1_options = [round(num, 2) for num in arange(-5, 5, .02)]
var2_options = [round(num, 2) for num in arange(-5, 5, .05)]

tested_values = {}
tolerance_reps = 10

# First Round:
var1 = choice(var1_options)
var2 = choice(var2_options)
actual_choice = {'var1': var1, 'var2': var2}
actual_tested_value = model(actual_choice.values())
tested_values['-'.join([str(num) for num in actual_choice.values()])] = actual_tested_value

optimized = False
minimum_reps_before_stop = 0

while not optimized:
  #minimum_reps_before_stop = 0
  before_random_columns = actual_tested_value
  print('\nBefore random columns model value:', actual_tested_value)
  random_columns = list(actual_choice.keys())
  shuffle(random_columns)
  for column in random_columns:
    old_choice = actual_choice
    old_tested_value = actual_tested_value
    actual_variable_index = locals()[column+'_options'].index(locals()[column])
    if actual_variable_index == 0:
      change = 1
    elif actual_variable_index == len(locals()[column+'_options'])-1:
      change = -1
    else:
      change = choice([-1, 1])
    #locals()[column] = locals()[column+'_options'][actual_variable_index+change]
    locals()[column] = choice(locals()[column+'_options'])
    actual_choice = {key: globals()[key] for (key, value) in actual_choice.items()}
    if '-'.join([str(num) for num in actual_choice.values()]) not in tested_values.keys():
      actual_tested_value = model(actual_choice.values())
    else:
      actual_tested_value = tested_values['-'.join([str(num) for num in actual_choice.values()])]
    print('\nIn column loop old model value:', old_tested_value)
    print('In column loop new model value:', actual_tested_value)
    tested_values['-'.join([str(num) for num in actual_choice.values()])] = actual_tested_value
    if actual_tested_value > old_tested_value:
      actual_choice = old_choice
      actual_tested_value = old_tested_value
  print('\nAfter random columns model value:', actual_tested_value)
  print('Reps', minimum_reps_before_stop)
  if actual_tested_value == before_random_columns and minimum_reps_before_stop == tolerance_reps:
    optimized = True
  if actual_tested_value < before_random_columns:
    minimum_reps_before_stop = 0
  if actual_tested_value == before_random_columns and minimum_reps_before_stop < tolerance_reps:
    minimum_reps_before_stop += 1

optimized_choice = actual_choice
optimized_tested_value = actual_tested_value
print('\nFinal Value:\n-', optimized_tested_value)
