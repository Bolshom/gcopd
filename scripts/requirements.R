#!/usr/bin/env Rscript

install.packages(c('devtools',
                   'dplyr',
                   'magrittr',
                   'ggplot2',
                   'xgboost'))

require(devtools)
options(devtools.install.args = c('--no-multiarch', '--no-test-load'))
install_url('https://github.com/catboost/catboost/releases/download/v0.17.2/catboost-R-Linux-0.17.2.tgz', INSTALL_opts=c('--no-multiarch', '--no-test-load'))
