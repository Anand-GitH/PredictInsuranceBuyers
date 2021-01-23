############################################################################
#Insurance company benchmark data set- to predict who will be intrested to
#buy caravan insurance using different regression methods
#Created By: Anand
#Date      : 10-12-2020
############################################################################
rm(list=ls())

set.seed(2020)

library("leaps")
library("glmnet")
library("tidyverse")

train.data <- read.table("ticdata2000.txt",sep="\t", header=FALSE)
colnames(train.data)<-c('MOSTYPE','MAANTHUI','MGEMOMV','MGEMLEEF','MOSHOOFD','MGODRK','MGODPR','MGODOV','MGODGE','MRELGE','MRELSA','MRELOV','MFALLEEN','MFGEKIND','MFWEKIND','MOPLHOOG','MOPLMIDD','MOPLLAAG','MBERHOOG','MBERZELF','MBERBOER','MBERMIDD','MBERARBG','MBERARBO','MSKA','MSKB1','MSKB2','MSKC','MSKD','MHHUUR','MHKOOP','MAUT1','MAUT2','MAUT0','MZFONDS','MZPART','MINKM30','MINK3045','MINK4575','MINK7512','MINK123M','MINKGEM','MKOOPKLA','PWAPART','PWABEDR','PWALAND','PPERSAUT','PBESAUT','PMOTSCO','PVRAAUT','PAANHANG','PTRACTOR','PWERKT','PBROM','PLEVEN','PPERSONG','PGEZONG','PWAOREG','PBRAND','PZEILPL','PPLEZIER','PFIETS','PINBOED','PBYSTAND','AWAPART','AWABEDR','AWALAND','APERSAUT','ABESAUT','AMOTSCO','AVRAAUT','AAANHANG','ATRACTOR','AWERKT','ABROM','ALEVEN','APERSONG','AGEZONG','AWAOREG','ABRAND','AZEILPL','APLEZIER','AFIETS','AINBOED','ABYSTAND','CARAVAN')
head(train.data)
dim(train.data)

test.data<- read.table("ticeval2000.txt",sep="\t",header=FALSE)
colnames(test.data)<-c('MOSTYPE','MAANTHUI','MGEMOMV','MGEMLEEF','MOSHOOFD','MGODRK','MGODPR','MGODOV','MGODGE','MRELGE','MRELSA','MRELOV','MFALLEEN','MFGEKIND','MFWEKIND','MOPLHOOG','MOPLMIDD','MOPLLAAG','MBERHOOG','MBERZELF','MBERBOER','MBERMIDD','MBERARBG','MBERARBO','MSKA','MSKB1','MSKB2','MSKC','MSKD','MHHUUR','MHKOOP','MAUT1','MAUT2','MAUT0','MZFONDS','MZPART','MINKM30','MINK3045','MINK4575','MINK7512','MINK123M','MINKGEM','MKOOPKLA','PWAPART','PWABEDR','PWALAND','PPERSAUT','PBESAUT','PMOTSCO','PVRAAUT','PAANHANG','PTRACTOR','PWERKT','PBROM','PLEVEN','PPERSONG','PGEZONG','PWAOREG','PBRAND','PZEILPL','PPLEZIER','PFIETS','PINBOED','PBYSTAND','AWAPART','AWABEDR','AWALAND','APERSAUT','ABESAUT','AMOTSCO','AVRAAUT','AAANHANG','ATRACTOR','AWERKT','ABROM','ALEVEN','APERSONG','AGEZONG','AWAOREG','ABRAND','AZEILPL','APLEZIER','AFIETS','AINBOED','ABYSTAND')
head(test.data)
dim(test.data)

x11()
#Check number of caravan policy
hist(train.data$CARAVAN)
carvanpol<-table(train.data$CARAVAN)
carvanpol

#Caravan is not a common thing to own lets verify with car policies
x11()
hist(train.data$APERSAUT)
carpol<-table(train.data$APERSAUT)
carpol

#Boat and Caravan are of similar - which are not a necessity
x11()
hist(train.data$APLEZIER)
boatpol<-table(train.data$APLEZIER)
boatpol

############################################################
#We have just 348 purchased caravan policy now we have to identify 
#what predictors has affect on the caravan policy purchase
#By estimating the beta coefficients of variables using different methods 
#we can infer the predictors that can influence caravan purchase

#1.Linear Regression
names(train.data)
linear.fit<-lm(CARAVAN~.,train.data)
linear.fit


summary(linear.fit)
confint(linear.fit)
linear.fit$coefficients

x11()
plot(linear.fit)

#########################################################
#2.Subset Selection - Forward
fwd.models<-regsubsets(CARAVAN~.,train.data,nvmax=86,method="forward")

fmod<-summary(fwd.models)$which

dim(fmod)
head(fmod)
frss<-summary(fwd.models)$rss

x11()
plot(1:length(frss),frss,xlab="No of variabes",ylab="Residual Sum of Squares",main="Forward Step Wise - Subset Selection",type="b")
coef(fwd.models,10)

#########################################################
#3.Subset Selection - Backward
back.models<-regsubsets(CARAVAN~.,train.data,nvmax=86,method="backward")

bmod<-summary(back.models)$which

dim(bmod)
head(bmod)
frss<-summary(back.models)$rss

x11()
plot(1:length(frss),frss,xlab="No of variabes",ylab="Residual Sum of Squares",main="Backward Step Wise - Subset Selection",type="b")
coef(back.models,10)

#########################################################
#4. LASSO Regression - Shrinkage method - reduces the coefficients of non significant predictors even reduce it to zero
s.train_data<-scale(train.data)
head(s.train_data)
lasso.fit<-cv.glmnet(s.train_data[,-86],s.train_data[,"CARAVAN"],nfolds=10,alpha=1)

head(lasso.fit$lambda)
cv.lambda<-lasso.fit$lambda.min
cv.lambda
lasso.pred.coef<-predict(lasso.fit,s=cv.lambda,type="coefficients")
lasso.pred.coef

#########################################################
#5.Ridge  Regression - Shrinkage method - reduces the coefficients but all predictors exists in the model
head(s.train_data)
ridge.fit<-cv.glmnet(s.train_data[,-86],s.train_data[,"CARAVAN"],nfolds=10,alpha=0)

head(ridge.fit$lambda)
cv.lambda<-ridge.fit$lambda.min
cv.lambda

ridge.pred.coef<-predict(ridge.fit,s=cv.lambda,type="coefficients")
ridge.pred.coef

#########################################################
