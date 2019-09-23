random_descent_optimization = function(f, ...){
  options = list(...)
  tested_values = list()
  
  # First round:
  fixed_choice = list()
  for (variable in names(options)){
    fixed_choice[[variable]] = sample(options[[variable]], 1)
  }
  fixed_tested_value = do.call(f, fixed_choice)
  tested_values[[paste(fixed_choice, collapse='-')]] = fixed_tested_value
  
  optimized = FALSE
  
  while (!optimized){
    before_random_columns = fixed_tested_value
    for (column in sample(names(options))){
      fixed_variable_index = which(options[[column]] == fixed_choice[[column]])
      if (fixed_variable_index == 1){
        changes = 1
      } else if (fixed_variable_index == length(options[[column]])) {
        changes = -1
      } else changes = c(-1, 1)
      for (change in changes){
        temp_choice = fixed_choice
        temp_choice[[column]] = options[[column]][fixed_variable_index+change]
        if (!(paste(temp_choice, collapse='-') %in% names(tested_values))){
          temp_tested_value = do.call(f, temp_choice)
          tested_values[[paste(temp_choice, collapse='-')]] = temp_tested_value
        } else temp_tested_value = tested_values[[paste(temp_choice, collapse='-')]]
        if (temp_tested_value < fixed_tested_value){
          fixed_choice = temp_choice
          fixed_tested_value = temp_tested_value
          break
        }
      }
    }
    if (fixed_tested_value == before_random_columns) optimized = TRUE
  }
  
  optimized_choice = fixed_choice
  optimized_tested_value = fixed_tested_value
  
  cat('\n* Optimized result:', optimized_tested_value, '\n')
  return(optimized_choice)
}