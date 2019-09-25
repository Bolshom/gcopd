rdo_jump = function(f, ...){
  options = list(...)
  tested_values = list()
  jump = 3
  past_changes = sapply(names(options), function(x) NULL)
  
  # First round:
  fixed_choice = list()
  trying = TRUE
  while (trying){
    for (variable in names(options)){
      fixed_choice[[variable]] = sample(options[[variable]], 1)
    }
    if (!(paste(fixed_choice, collapse='-') %in% names(tested_values))){
      fixed_tested_value = do.call(f, fixed_choice)
      tested_values[[paste(fixed_choice, collapse='-')]] = fixed_tested_value
    } else fixed_tested_value = tested_values[[paste(fixed_choice, collapse='-')]]
    trying = ifelse(is.nan(fixed_tested_value), TRUE, FALSE)
  }
  
  optimized = FALSE
  
  while (!optimized){
    before_random_columns = fixed_tested_value
    for (column in sample(names(options))){
      fixed_variable_index = which(options[[column]] == fixed_choice[[column]])
      if (fixed_variable_index == 1){
        changes = 1
      } else if (fixed_variable_index == length(options[[column]])) {
        changes = -1
      } else if (length(past_changes[[column]])>=jump & length(unique(past_changes[[column]]))==1) {
        changes = sum(past_changes[[column]])
        past_changes[[column]] = NULL
      } else changes = c(-1, 1)
      for (change in changes){
        temp_choice = fixed_choice
        if ((fixed_variable_index+change > length(options[[column]])) |
            (fixed_variable_index+change < 0)){
          change = round(change/jump)
        }
        temp_choice[[column]] = options[[column]][fixed_variable_index+change]
        if (!(paste(temp_choice, collapse='-') %in% names(tested_values))){
          temp_tested_value = do.call(f, temp_choice)
          tested_values[[paste(temp_choice, collapse='-')]] = temp_tested_value
        } else temp_tested_value = tested_values[[paste(temp_choice, collapse='-')]]
        if (!is.nan(temp_tested_value)){
          if (temp_tested_value < fixed_tested_value){
            fixed_choice = temp_choice
            fixed_tested_value = temp_tested_value
            if (change %in% c(-1, 1)) past_changes[[column]] = c(past_changes[[column]], change)
            break
          }
        } else temp_choice[[column]] = sample(options[[column]], 1)
      }
    }
    if (fixed_tested_value == before_random_columns) optimized = TRUE
  }
  
  optimized_choice = fixed_choice
  optimized_tested_value = fixed_tested_value
  
  return(list('value'=optimized_tested_value, 'choices'=optimized_choice))
}

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