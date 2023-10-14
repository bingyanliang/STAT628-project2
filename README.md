# STAT628-project2 by group 2

## Introduction

This repository is for storing our source code for STAT628 class project 2.

We seperated our task to several parts, for each person, we are going to:

- Preethi: cleaning the data, fit and evaluate decision tree model, preparing the summary
- Yidan: cleaning the data, fit and evaluate the linear regression model, preparing the presentation materials
- Bingyan: fit and evaluate random forest model, make the shiny app, maintaining the github project

The basic structure of this repository is four directories:

- data: contains the raw data and our cleaned data, contributed by Preethi and Yidan
- sourcecode: code for the data analysis, contributed by Preethi, Yidan and Bingyan
- image: images that we produced to visualize the analysis process and result
- myapp: the shiny app source code developed by Bingyan

## Guideline

Here is the workflow of our work and hope it could give you reference to use the code.

First, we cleaned the data using Z-score method, using the matlab file bodyfatcleaning.m generate by Preethi, then we re-calculated the points where bodyfat data is 0, using XXX generated by Yidan.

Second, we considered three different models: linear regression, decision tree and random forest. To fit and evaluate the performance of the models, we seperated our task. The sourcecode/linear regression.R is generated by Yidan, contains the code of the linear regression and the process we select predictors. sourcecode/randomforest.ipynb is generated in Colaboratry by Bingyan, containing the RFE method to select predictors and models fitted.decisiontree.m is generdted by Preethi,containing entropy method to select predictors.

Third, comparing the MSE of our results, we choose linear regression as our final model.



