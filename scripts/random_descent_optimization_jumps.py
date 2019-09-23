from random import choice, shuffle

def random_descent_optimization(function, **kwargs):
    #Creating var_options from input
    for key,value in kwargs.items():
        globals()[key+'_options'] = list(value)
    
    tested_values = {}
    past_changes = {key: [] for key in kwargs.keys()}
    
    #First round:
    fixed_choice = {key: choice(globals()[key+'_options']) for key in kwargs.keys()}
    fixed_tested_value = function(**fixed_choice)
    tested_values['-'.join([str(num) for num in fixed_choice.values()])] = fixed_tested_value
    
    optimized = False
    
    while not optimized:
        before_random_columns = fixed_tested_value
        random_columns = list(fixed_choice.keys())
        shuffle(random_columns)
        for column in random_columns:
            fixed_variable_index = globals()[column+'_options'].index(fixed_choice[column])
            if fixed_variable_index == 0:
                changes = [1]
            elif fixed_variable_index == len(globals()[column+'_options'])-1:
                changes = [-1]
            elif len(past_changes[column])==2 and len(set(past_changes[column]))==1:
                #print('\n\n', past_changes, '\n\n')
                changes = [sum(past_changes[column])]
                past_changes[column] = []
            else:
                changes = [-1, 1]
            for change in changes:
                temp_choice = {key: value for (key, value) in fixed_choice.items()}
                temp_choice[column] = globals()[column+'_options'][fixed_variable_index+change]
                if '-'.join([str(num) for num in temp_choice.values()]) not in tested_values.keys():
                    temp_tested_value = function(**temp_choice)
                    tested_values['-'.join([str(num) for num in temp_choice.values()])] = temp_tested_value
                else:
                    temp_tested_value = tested_values['-'.join([str(num) for num in temp_choice.values()])]
                if temp_tested_value < fixed_tested_value:
                    fixed_choice = {key: value for (key, value) in temp_choice.items()}
                    fixed_tested_value = temp_tested_value
                    if change in [-1, 1]:
                      past_changes[column].append(change)
                    break
        if fixed_tested_value == before_random_columns:
            optimized = True
        
    optimized_choice = fixed_choice
    optimized_tested_value = fixed_tested_value
    
    print('\n* Optimized result:', optimized_tested_value)
    return optimized_tested_value
