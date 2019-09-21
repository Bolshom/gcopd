require(magrittr); require(dplyr); require(xgboost); require(ggplot2)


BASE_DIR = '/basedir/estimation/120619'
setwd(BASE_DIR)

database = readRDS('../../dataset/12062019.RDS')

train = data.frame()
test = data.frame()

for (ind in unique(database$id)){
  test %<>% rbind(.,
                  database %>%
                    filter(id==ind &
                             period == database[database$id==ind, 'period'] %>% max &
                             period > 1))
  train %<>% rbind(.,
                   database %>%
                     filter(id==ind &
                              (period != database[database$id==ind, 'period'] %>% max |
                                 period == 1)))
}

train %<>% select(-id, -period)
test %<>% select(-id, -period)

etas = seq(.01, .2, .05)
max_depths = seq(3, 10, 1)
subsamples = seq(.5, 1, .1)
colsamples_bytree = seq(.5, 1, .1)

parameters = expand.grid(etas, max_depths,
                         subsamples, colsamples_bytree) %>%
  set_colnames(c('eta', 'max_depth', 'subsample', 'colsample_bytree'))
parameters$rmse = 0

importances = list()

for (row in 1:nrow(parameters)){
  model = xgboost(data.matrix(train[, -1]),
                          as.numeric(train$ftpdiff),
                          early_stopping_rounds=10,
                          nrounds=10000,
                          eta=parameters$eta[row],
                          max_depth=parameters$max_depth[row],
                          subsample=parameters$subsample[row],
                          colsample_bytree=parameters$colsample_bytree[row])
  
  predictions = predict(model, data.matrix(test[, -1]))
  parameters$rmse[row] = sqrt(mean((predictions-as.numeric(test$ftpdiff))^2))
  
  importances[[row]] = xgb.importance(model=model)
  
  saveRDS(model, paste0('models/xgb_', row, '.RDS'))
}

saveRDS(importances, 'xgb_importances.RDS')
saveRDS(parameters, 'xgb_parameters.RDS')

parameter = parameters[which.min(parameters$rmse), ]

model = xgboost(data.matrix(database %>% select(-ftpdiff, -id, -period)),
                as.numeric(database$ftpdiff),
                early_stopping_rounds=10,
                nrounds=10000,
                eta=parameter$eta,
                max_depth=parameter$max_depth,
                subsample=parameter$subsample,
                colsample_bytree=parameter$colsample_bytree)

importance = xgb.importance(model=model)

saveRDS(model, 'xgb_final_model.RDS')

ggplot(importance %>% arrange(desc(Gain)) %>% head(10),
       aes(reorder(Feature, -Gain, sum), Gain)) +
  geom_col() +
  xlab('Feature')

ggplot(importance %>% arrange(desc(Cover)) %>% head(10),
       aes(reorder(Feature, -Cover, sum), Cover)) +
  geom_col() +
  xlab('Feature')

ggplot(importance %>% arrange(desc(Frequency)) %>% head(10),
       aes(reorder(Feature, -Frequency, sum), Frequency)) +
  geom_col() +
  xlab('Feature')
