setwd('/basedir/estimation/30d')
source('../../functions/random_descent_optimization_parallel.R', encoding='utf-8')


estimation = function(...) {
  variables = data.frame(...)
  tss_col = which(grepl('tss', colnames(variables)))
  int_variables = variables[, colnames(variables)[grep('X', colnames(variables))]]
  
  tss = function(vector){
    total_seconds = length(vector)
    ma30s = zoo::rollmean(vector, 30)
    mean_fourth = mean(ma30s^4)
    
    return(round(total_seconds*sqrt(mean_fourth)/36))
  }
  
  avg_day_tss = tss(unlist(sapply(names(int_variables),
                                  function(int) rep(
                                    as.numeric(gsub('X', '', int))/100,
                                    int_variables[, int]),
                                  USE.NAMES=F)))
  if (is.nan(avg_day_tss)) return(NaN)
  if ((avg_day_tss*5 > variables[, tss_col] + .05*variables[, tss_col]) |
      (avg_day_tss*5 < variables[, tss_col] - .05*variables[, tss_col])) return(NaN)
  
  model = readRDS('/basedir/estimation/30d/xgb_final_model.RDS')
  
  return(-predict(model, data.matrix(variables)))
}

params = list(f=estimation,
              w=c(65, 66),
              bpmmin=c(55, 56),
              bpmmax=c(198, 199),
              tssmed=seq(200, 700, 50),
              d=c(15, 30))
int_params = sapply(paste0('X', 1:300), function(x) NULL)
for (int in 1:30) int_params[[paste0('X', int)]] = c(0, 10, 15, 20, 30, 60)
for (int in 31:100) int_params[[paste0('X', int)]] = c(0, .25, seq(.5, 5, .5)) * 60
for (int in 101:130) int_params[[paste0('X', int)]] = c(0, 10, 15, 20, 30, 40, 50, 60)
for (int in 131:300) int_params[[paste0('X', int)]] = c(0, 1, 5, 10)

optimization = do.call(rdo_jump, c(params, int_params))
saveRDS(optimization, 'optimization.RDS')
