from rdo_jump import rdo_jump

def random_descent_optimization(function, **kwargs):
    reps = 10
    pre_results = {trial: rdo_jump(function, **kwargs) for trial in range(reps)}

    values = [pre_results[index]['value'] for index in pre_results.keys()]

    optimized_tested_value = min(values)
    optimized_choice = pre_results[values.index(optimized_tested_value)]['choices']
    
    
    print('\n* Optimized result:', optimized_tested_value)
    return {'value': optimized_tested_value, 'choices': optimized_choice}
