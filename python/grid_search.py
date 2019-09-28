from itertools import product


def grid_search(function, pre_tested_values={}, **kwargs):
    # Creating var_options from input
    for key,value in kwargs.items():
        globals()[key+'_options'] = list(value)
    
    all_combinations = list(product(*[globals()[key+'_options'] for
        key in kwargs.keys()]))
    
    tested_values = {'|'.join([str(num) for num in combination]):
        function(*combination) for combination in all_combinations}
        
    optimized_tested_value = min(tested_values.values())
    optimized_choice = min(tested_values, key=tested_values.get)
    optimized_choice = {list(kwargs.keys())[index]:
        optimized_choice.split('|')[index] for
        index in range(len(kwargs.keys()))}
    
    return {'value': optimized_tested_value, 'choices': optimized_choice,
        'tested_values': {**pre_tested_values, **tested_values}}