from math import isnan
from random import choice, sample, shuffle

from numpy import array_split

from grid_search import grid_search
from rdo_jump import rdo_jump


def genetic_random_descent(function, **kwargs):
    for key,value in kwargs.items():
        globals()[key+'_initial_options'] = list(value)
    
    number_of_chunks = 5
    evolving = {key: True for key in kwargs.keys()}
    tested_values = {}
    
    while any(evolving.values()):
        splitted_groups = {}
        population = {}
        for key in kwargs.keys():
            if evolving[key]:
                splitted_groups[key] = [list(chunk) for chunk in
                    array_split(globals()[key+'_initial_options'], number_of_chunks)]
                population[key] = [sample(split, 2) for split in splitted_groups[key]]
                population[key] = sum(population[key], [])
            else:
                splitted_groups[key] = [globals()[key+'_initial_options']]
                population[key] = globals()[key+'_initial_options']
        
        optimization_algorithm = grid_search(function, tested_values, **population)
        tested_values = optimization_algorithm['tested_values']
        best_individual = optimization_algorithm['choices']
        round_optimized_value = optimization_algorithm['value']
        
        for key in kwargs.keys():
            globals()[key+'_initial_options'] = splitted_groups[key][\
                [float(best_individual[key]) in list for list in\
                splitted_groups[key]].index(True)]
            evolving[key] = False if len(globals()[key+'_initial_options']) <= number_of_chunks*2 else True
    
    population = {key: globals()[key+'_initial_options'] for key in kwargs.keys()}
    optimization_algorithm = grid_search(function, tested_values, **population)

    return {'value': optimization_algorithm['value'],
        'choices': optimization_algorithm['choices']}


def genetic_random_descent_optimization(function, **kwargs):
    reps = 1
    pre_results = {trial: genetic_random_descent(function, **kwargs) for trial in range(reps)}

    values = [pre_results[index]['value'] for index in pre_results.keys()]

    optimized_tested_value = min(values)
    optimized_choice = pre_results[values.index(optimized_tested_value)]['choices']
    
    
    print('\n* Optimized result:', optimized_tested_value)
    return {'value': optimized_tested_value, 'choices': optimized_choice}
