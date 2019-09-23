source('/basedir/scripts/random_descent_optimization.R', encoding='utf-8')


model = function(var1, var2){
  return(var1^2 + var2^2)
}


var1_options = seq(-5, 5, .02)
var2_options = seq(-5, 5, .05)

start = Sys.time()

cat('*** START RANDOM SEARCH ***\n')

optimized_result = random_descent_optimization(model, var1=var1_options, var2=var2_options)

end = Sys.time()

cat('\n* Elapsed time:', end-start, '\n')

start = Sys.time()

cat('*** START GRID SEARCH ***\n')

all_combinations = expand.grid(var1=var1_options, var2=var2_options)
all_combinations$tested_values = NA
for (row in 1:nrow(all_combinations)){
  all_combinations$tested_values[row] = model(
    all_combinations[row, 'var1'], all_combinations[row, 'var2']
  )
}
optimized_tested_value = min(all_combinations$tested_values)
optimized_row = which.min(all_combinations$tested_values)
optimized_choice = list('var1'=all_combinations[optimized_row, 'var1'],
                        'var2'=all_combinations[optimized_row, 'var2'])

cat('\n* Optimized result:', optimized_tested_value, '\n')

end = Sys.time()

cat('\n* Elapsed time:', end-start)
