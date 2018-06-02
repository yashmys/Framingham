install.packages('caTools')
install.packages()
library('tidyverse')
library('caTools')
library('ROCR')


framdata <-  read.csv("framingham.csv")
dim(framdata)
str(framdata)

table(framdata$TenYearCHD)
table(framdata$cigsPerDay)
table(framdata$currentSmoker)

set.seed(1000)
sample <- sample.split(framdata$TenYearCHD,SplitRatio  = 0.65)
#sample


train <-  subset(framdata,sample == TRUE)
test <-  subset(framdata,sample == FALSE)

nrow(train)
nrow(test)

framdatalg <-  glm(train$TenYearCHD ~ . ,data = train , family = binomial)
summary(framdatalg)

predicttest <- predict(framdatalg,type = "response", newdata = test)

table(test$TenYearCHD, predicttest > 0.5)

ROCRpred <- prediction(predicttest,test$TenYearCHD)
summary(ROCRpred)
ROCRpred

as.numeric((performance(ROCRpred,"auc")@y.values))
