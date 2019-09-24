setwd('F:/gcopd_modeling/estimation/30d')
source('../../functions/rdo_jump.R', encoding='utf-8')
source('../../functions/tss.R', encoding='utf-8')

model = readRDS('xgb_final_model.RDS')


estimation = function(...) {
  variables = data.frame(...)
  tss_col = which(grepl('tss', colnames(variables)))
  int_variables = variables[, colnames(variables)[grep('X', colnames(variables))]]
  avg_day_tss = tss(unlist(sapply(names(int_variables),
                                  function(int) rep(
                                    as.numeric(gsub('X', '', int))/100,
                                    int_variables[, int]),
                                  USE.NAMES=F)))
  if (is.nan(avg_day_tss)) return(0)
  if ((avg_day_tss*5 > variables[, tss_col] + .05*variables[, tss_col]) |
      (avg_day_tss*5 < variables[, tss_col] - .05*variables[, tss_col])) return(0)
  return(-predict(model, data.matrix(variables)))
}

params = list(f=estimation,
              w=c(65, 70),
              bpmmin=40:50,
              bpmmax=190:200,
              tssmed=seq(700, 800, 10),
              d=c(15, 30))
int_params = sapply(paste0('X', 1:300), function(x) NULL)
for (int in 1:300){
  int_params[[paste0('X', int)]] = seq(60, 20*60, 60)
}

optimization = do.call(rdo_jump, c(params, int_params))
