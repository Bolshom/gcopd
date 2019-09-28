setwd('F:/gcopd_modeling/estimation/30d')
source('../../functions/random_descent_optimization_parallel.R', encoding='utf-8')
source('../../functions/tss.R', encoding='utf-8')


estimation = function(...) {
  variables = data.frame(...)
  #tss_col = which(grepl('tss', colnames(variables)))
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
  if ((avg_day_tss<0)|(avg_day_tss>200)) return(NaN)
  variables[, 'tssmed'] = avg_day_tss*5
  if (is.nan(avg_day_tss)) return(NaN)
  variables = rbind(variables[, c('w', 'bpmmin', 'bpmmax', 'tssmed', 'd')],
                    int_variables)
  #if ((avg_day_tss*5 > variables[, tss_col] + .05*variables[, tss_col]) |
  #    (avg_day_tss*5 < variables[, tss_col] - .05*variables[, tss_col])) return(NaN)
  return(-predict(model, data.matrix(variables)))
}

model = readRDS('xgb_final_model.RDS')

params = list(f=estimation,
              w=c(65, 70),
              bpmmin=c(40, 45, 50),
              bpmmax=c(190, 195, 200),
              tssmed=c(700, 750, 800),
              d=c(15, 30))
int_params = sapply(paste0('X', 1:300), function(x) NULL)
for (int in 1:100) int_params[[paste0('X', int)]] = c(0, .5, 1, 2, 5, 10, 20, 30, 60, 120) * 60
for (int in 101:130) int_params[[paste0('X', int)]] = c(0, .5, 1, 2, 5) * 60
for (int in 131:300) int_params[[paste0('X', int)]] = c(0, .25, .5) * 60

optimization = do.call(rdo_jump, c(params, int_params))