require(magrittr); require(dplyr); require(ggplot2)


BASE_DIR = '/basedir/estimations/external'
setwd(BASE_DIR)

xgboost_30d = readRDS('../30d/xgb_final_model.RDS')
xgboost_120619 = readRDS('../120619/xgb_final_model.RDS')

database = readRDS('../../dataset/external.RDS')

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

saveRDS(pred_xgboost_30d, 'predictions/xgboost_30d')
saveRDS(pred_xgboost_120619, 'predictions/xgboost_120619')

cat('\n--------------------',
    '\nRMSE - XGBoost 30d:\n-', sqrt(mean((pred_xgboost_30d-as.numeric(database$ftpdiff))^2)),
    '\nRMSE - XGBoost 120619:\n-', sqrt(mean((pred_xgboost_120619-as.numeric(database$ftpdiff))^2)),
    '\n--------------------')
