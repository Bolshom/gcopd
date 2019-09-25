setwd('F:/gcopd_modeling/estimation/30d')
source('../../functions/random_descent_optimization.R', encoding='utf-8')


model = function(var1, var2){
  return(exp(var1+var2) * var1^2 + var2^3 * (var1+var2)^5)
}


var1_options = seq(-5, 5, .02)
var2_options = seq(-5, 5, .05)

trials = list(
  'random'=list('result'=c(), 'time'=c()),
  'grid'=list('result'=c(), 'time'=c())
)


for (trial in 1:10){

start = Sys.time()

cat('*** START RANDOM SEARCH ***\n')

optimized = random_descent_optimization(model, var1=var1_options, var2=var2_options)

end = Sys.time()

cat('\n* Elapsed time:', end-start, '\n')

trials[['random']][['result']] = c(trials[['random']][['result']], optimized[['value']])
trials[['random']][['time']] = c(trials[['random']][['time']], end-start)

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

cat('\n* Elapsed time:', end-start, '\n')

trials[['grid']][['result']] = c(trials[['grid']][['result']], optimized_tested_value)
trials[['grid']][['time']] = c(trials[['grid']][['time']], end-start)
}

cat('\nMean time for Random Search:', mean(trials[['random']][['time']]), '\n')
cat('\nMean time for Grid Search:', mean(trials[['grid']][['time']]), '\n')
