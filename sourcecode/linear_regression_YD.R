rm(list=ls())
data<-read.csv("cleaned_bodyfat.csv")
data<-data[,c(-1,-3)]
#best subset selection->cross validation->one-standard-error rule
library(leaps)
k<-10
n<-nrow(data)
set.seed(1)
folds<-sample(rep(1:k,length=n))
cv.errors<-matrix(NA,k,14,dimnames=list(NULL,paste(1:14)))
predict.regsubsets<-function(object,newdata,id,...)
{
  form<-as.formula(object$call[[2]])
  mat<-model.matrix(form,newdata)
  coefi<-coef(object,id=id)
  xvars<-names(coefi)
  mat[,xvars]%*%coefi
}
for(j in 1:k){
  best.fit<-regsubsets(BODYFAT~.,data=data[folds!=j,],nvmax=14)
  for(i in 1:14){
    pred<-predict(best.fit,data[folds==j,],id=i)
    cv.errors[j,i]<-mean((data$BODYFAT[folds==j]-pred)^2)
    }
}
mean.cv.errors<-apply(cv.errors,2,mean)
mean.cv.errors
plot(1:14,mean.cv.errors,col="blue",type="b",xlab="number of predictor",ylab="Cross-Validation Error")
coef(best.fit,3)#height,abdomen,wrist
sd<-sqrt(var(cv.errors[,3])) #based on the one-standard-error rule, we select the model with one preditors abdomen
#estimated test error:18.711
#################################################################################
#Lasso regression(cv->lambda)
rm(list=ls())
data<-read.csv("cleaned_bodyfat.csv")
data<-data[,c(-1,-3)]
library(glmnet)
set.seed(1) # for reproducibility
x <- as.matrix(data[,2:14])
y <- as.vector(data$BODYFAT)
lasso.fit <- glmnet(x, y, alpha=1)
plot(lasso.fit, xvar="lambda", label=TRUE)
cv.fit <- cv.glmnet(x,y, alpha=1) 
best_lambda <- cv.fit$lambda.min
plot(cv.fit)
best_lambda <- cv.fit$lambda.1se#In practical applications, to maintain a certain level of model simplicity and interpretability, people often use the "one-standard-error rule." This means that, instead of choosing the λ value that minimizes the cross-validation error, we select a larger λ value whose error is within one standard error of the minimum error
lasso.fit <- glmnet(x, y, alpha=1, lambda=best_lambda)
coef(lasso.fit)#age,height,abdomen,ankle
estimated_test_error <- cv.fit$cvm[cv.fit$lambda == best_lambda]
estimated_test_error#estimated test error:17.427
########################################################################################3
#PCR
rm(list=ls())
data<-read.csv("cleaned_bodyfat.csv")
data<-data[,c(-1,-3)]
library(pls)
set.seed(1)
pcr.fit<-pcr(BODYFAT~.,data=data,scale=TRUE,validation="CV")
summary(pcr.fit)
validationplot(pcr.fit,val.type="MSEP")#select four components
cv_results <- MSEP(pcr.fit)#estimated test error:19.83


