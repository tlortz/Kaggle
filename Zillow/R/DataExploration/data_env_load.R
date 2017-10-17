library(tidyverse)
library(stringr)
library(data.table)
raw_properties_full <- fread("/Users/tim/Data/Kaggle/Zillow/properties_2016.csv",data.table = FALSE)
transactions_full <- fread("/Users/tim/Data/Kaggle/Zillow/train_2016_v2.csv",data.table = FALSE)
minTransactionYear <- 2016
month_lookup <- data.frame(index=c(10,11,12,22,23,24),month=c("201610","201611","201612","201710","201711","201712"))

# add age of house, as a transformation on the buildyear var
raw_properties_full <- mutate(raw_properties_full,property_age=2017-yearbuilt)
raw_properties_full <- raw_properties_full %>% mutate(census = as.character(rawcensustractandblock), tract_number = as.factor(str_sub(census,5,11)), tract_block = as.factor(str_sub(census,12)))

# extract month and year from transaction date, as potential model features
min_date = min(transactions_full$transactiondate)
#transactions_full <- mutate(transactions_full, transaction_year=year(transactiondate),transaction_month=month.abb[lubridate::month(transactiondate)])
transactions_full <- mutate(transactions_full, transaction_year=year(transactiondate),
                            transaction_month=month(transactiondate))
transactions_full$month_index <- sapply(transactions_full$transactiondate,function(x) {12*(year(x)-minTransactionYear)+month(x)})
transactions_full$transaction_month = as.factor(transactions_full$transaction_month)
transactions_full$transaction_year = as.factor(transactions_full$transaction_year)
