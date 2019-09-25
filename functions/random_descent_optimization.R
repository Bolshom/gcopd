source('../../functions/rdo_jump.R', encoding='utf-8')


random_descent_optimization = function(f, ...){
  reps = 10
  pre_results = list()
  for (trial in 1:reps) pre_results[[trial]] = rdo_jump(f, ...)
  
  values = sapply(pre_results, function(result) result[['value']])
  
  optimized_tested_value = min(values)
  optimized_choice = pre_results[[which.min(values)]][['choices']]
  
  cat('\n* Optimized result:', optimized_tested_value, '\n')
  
  return(list('value'=optimized_tested_value, 'choices'=optimized_choice))
}