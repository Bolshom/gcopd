require(magrittr); require(dplyr); require(ggplot2)


BASE_DIR = 'E:/Faculdade/Monografia/Banco de Dados/GCOPD External'
setwd(BASE_DIR)

xgboost_30d = readRDS('../GCOPD 30d/xgboost/final_model.RDS')
xgboost_120619 = readRDS('../GCOPD 12-06-2019/xgboost/final_model.RDS')
source('E:/Faculdade/Monografia/Funções/ftp_diff_posterior.R', encoding='utf-8')
source('E:/Faculdade/Monografia/Funções/mode.R', encoding='utf-8')

database = readRDS('model_database_3by3.RDS')

pred_xgboost_30d = predict(xgboost_30d,
                           database %>%
                             select(-ftpdiff, -id, -period, -gender) %>%
                             set_colnames(c('w', 'bpmmin', 'bpmmax', 'tssmed', 'd',
                                            colnames(database[, 10:109]))) %>%
                             data.matrix
)

pred_xgboost_120619 = predict(xgboost_120619,
                              database %>% select(-ftpdiff, -id, -period) %>%
                                data.matrix
)

pred_bayesian_30d = c()
new_database = database %>% select(weight, hr_max, tss, d,
                               X37X39, X46X48, X85X87, X91X93, X109X111,
                               X205X207, X286X288, X298X300)
for (row in 1:nrow(new_database)){
  pred_bayesian_30d[row] = ftp_diff_posterior(new_database[row, ]) %>%
    mode
}

saveRDS(pred_xgboost_30d, 'predictions/xgboost_30d')
saveRDS(pred_xgboost_120619, 'predictions/xgboost_120619')
saveRDS(pred_bayesian_30d, 'predictions/pred_bayesian_30d')

pred_bayesian_30d %<>% imputeTS::na_mean(.)

cat('\n--------------------',
    '\nRMSE - XGBoost 30d:\n-', sqrt(mean((pred_xgboost_30d-as.numeric(database$ftpdiff))^2)),
    '\nRMSE - XGBoost 120619:\n-', sqrt(mean((pred_xgboost_120619-as.numeric(database$ftpdiff))^2)),
    '\nRMSE - Bayesian 30d:\n-', sqrt(mean((pred_bayesian_30d-as.numeric(database$ftpdiff))^2)),
    '\n--------------------')
