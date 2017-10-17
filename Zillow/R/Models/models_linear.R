library(caret)
library(rpart)
library(randomForest)

parcels_scored <- unique(transactions_full$parcelid)
in_vars <- c("bedroomcnt","bathroomcnt","roomcnt","taxamount","property_age","transaction_month",
             "tract_number","tract_block")
target <- c("logerror")

model_properties <- inner_join(populated_properties,transactions_full) %>%
  select(one_of(union(in_vars,target)))

model_properties_sample <- sample_n(model_properties,10000)

lm_base <- lm(logerror~.,data = model_properties)
summary(lm_base)
plot(lm_base$residuals,type="l")
boxplot(lm_base$residuals)
mean(lm_base$residuals^2)

'
trainIndex <- createDataPartition(model_properties$logerror,p=.7,list = FALSE,times = 1)
train <- model_properties[trainIndex,]
test <- model_properties[-trainIndex]
'

lin_fit <- caret::train(logerror~.,data = model_properties_sample,method = "lm",na.action = na.omit,preProcess=c("center","scale"))

tree_fit <- caret::train(logerror~.,data = model_properties_sample,method = "rpart",na.action = na.omit,preProcess=c("center","scale"))

rf_fit <- caret::train(logerror~.,data = model_properties_sample,method = "rf",na.action = na.omit,preProcess=c("center","scale"))
