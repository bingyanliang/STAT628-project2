rm(list=ls())
data<-read.csv("cleaned_bodyfat2.csv")


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
sd<-sqrt(var(cv.errors[,3]))
final.model <- lm(BODYFAT ~ HEIGHT + ABDOMEN + WRIST, data=data)
R2 <- summary(final.model)$r.squared
print(paste("R-squared:", R2))#0.7069
residuals <- residuals(final.model)
MSE <- mean(residuals^2)#15.6092
print(paste("Mean Squared Error:", MSE))
final.model$coefficients#-0.38806,0.72284,-1.4684

plot(final.model,which=1)
plot(final.model, which=2)
plot(final.model, which=3)

plot(final.model)
install.packages("car")
library(car)
influencePlot(final.model, id.method="identify", main="Influence Plot", sub="Circle size is proportional to Cook's Distance")
#delete 185
data2<-data[-185,]
model1<-lm(BODYFAT ~ HEIGHT + ABDOMEN + WRIST, data=data2)
summary(model1)
model1$coefficients#-0.4075,0.7176,-1.4768
R21 <- summary(model1)$r.squared
print(paste("R-squared:", R21))#0.7127
residuals1 <- residuals(model1)
MSE1 <- mean(residuals1^2)
print(paste("Mean Squared Error:", MSE1))#15.4713

#delete 240
data3<-data[-240,]
model2<-lm(BODYFAT ~ HEIGHT + ABDOMEN + WRIST, data=data3)
model2$coefficients#-0.4078,0.7319,-1.5092
R22 <- summary(model2)$r.squared
print(paste("R-squared:", R22))#0.7172
residuals2 <- residuals(model2)
MSE2 <- mean(residuals2^2)
print(paste("Mean Squared Error:", MSE2))#15.4949

#delete 229
data4<-data[-229,]
model3<-lm(BODYFAT ~ HEIGHT + ABDOMEN + WRIST, data=data4)
summary(model3)
model3$coefficients#-0.3946,0.7334,-1.5148
R23 <- summary(model3)$r.squared
print(paste("R-squared:", R23))#0.7195
residuals3 <- residuals(model3)
MSE3 <- mean(residuals3^2)
print(paste("Mean Squared Error:", MSE3))#15.4072





actual_values <- data$BODYFAT
predicted_values <- predict(final.model, data=data)

lower_bound <- actual_values * 0.9
upper_bound <- actual_values * 1.1

within_range <- (predicted_values >= lower_bound) & (predicted_values <= upper_bound)

percentage_within_range <- mean(within_range) * 100

print(percentage_within_range)





#################################################################################
#Lasso regression(cv->lambda)
rm(list=ls())
data<-read.csv("cleaned_bodyfat.csv")
data<-data[,c(-1,-3)]
library(glmnet)
set.seed(1) # for reproducibility
x <- as.matrix(data[,2:15])
y <- as.vector(data$BODYFAT)
lasso.fit <- glmnet(x, y, alpha=1)
plot(lasso.fit, xvar="lambda", label=TRUE,lwd=1.5)
cv.fit <- cv.glmnet(x,y, alpha=1) 
best_lambda <- cv.fit$lambda.min
plot(cv.fit,col="blue")
best_lambda <- cv.fit$lambda.1se#In practical applications, to maintain a certain level of model simplicity and interpretability, people often use the "one-standard-error rule." This means that, instead of choosing the λ value that minimizes the cross-validation error, we select a larger λ value whose error is within one standard error of the minimum error
lasso.fit <- glmnet(x, y, alpha=1, lambda=best_lambda)
coef(lasso.fit)#age,height,abdomen,wrist

predictions <- predict(lasso.fit, s = best_lambda, newx = x)

mse <- mean((y - predictions)^2)

ss_res <- sum((y - predictions)^2)  
sst <- sum((y - mean(y))^2)  
r_squared <- 1 - ss_res/sst


mse#16.5052
r_squared#0.6996

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
pcr.fit.best <- pcr(BODYFAT~., data=data, scale=TRUE, ncomp=4)
predictions <- predict(pcr.fit.best, ncomp=4)
loadings(pcr.fit.best)

mse <- mean((data$BODYFAT - predictions)^2)

ss_res <- sum((data$BODYFAT - predictions)^2)  
sst <- sum((data$BODYFAT - mean(data$BODYFAT))^2)

r_squared <- 1 - ss_res/sst


mse#18.8090
r_squared#0.6577



