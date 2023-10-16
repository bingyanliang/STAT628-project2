# Load necessary libraries
library(caret)
library(rpart)
library(rpart.plot)

# Read the CSV file
data <- read.csv("C:/Users/preet/Downloads/cleaned_bodyfatfinal.csv")

# Define selected features
selectedColumns <- c('AGE', 'WEIGHT', 'HEIGHT', 'NECK', 'CHEST', 'ABDOMEN', 'HIP', 'THIGH', 'KNEE', 'ANKLE', 'BICEPS', 'FOREARM', 'WRIST')

# Extract selected features and target variable
selectedData <- data[selectedColumns]
target <- data$BODYFAT

# Build a decision tree model
model <- rpart(BODYFAT ~ ., data = data)

# Display the decision tree plot
rpart.plot(model)

# Create a new data frame with the selected features
selectedData <- data[selectedColumns]

# Configure k-fold cross-validation
numFolds <- 5
set.seed(123)  # Set seed for reproducibility

# Initialize arrays to store MSE and R-squared values
mseValues <- numeric(numFolds)
rsquaredValues <- numeric(numFolds)

# Perform k-fold cross-validation
folds <- createFolds(target, k = numFolds, list = TRUE, returnTrain = FALSE)

for (fold in 1:numFolds) {
  testIndices <- unlist(folds[fold])
  trainData <- selectedData[-testIndices, ]
  trainTarget <- target[-testIndices]
  testData <- selectedData[testIndices, ]
  testTarget <- target[testIndices]
  
  # Build a decision tree model for this fold
  model <- rpart(trainTarget ~ ., data = trainData)
  
  # Make predictions
  predictions <- predict(model, newdata = data.frame(testData))
  
  # Calculate Mean Squared Error (MSE) for this fold
  mseValues[fold] <- mean((testTarget - predictions)^2)
  
  # Calculate R-squared for this fold
  sst <- sum((testTarget - mean(testTarget))^2)  # Total sum of squares
  ssr <- sum((testTarget - predictions)^2)       # Residual sum of squares
  rsquaredValues[fold] <- 1 - (ssr / sst)
}

# Calculate the average MSE and R-squared values across all folds
averageMSE <- mean(mseValues)
averageRSquared <- mean(rsquaredValues)

cat("Mean Squared Error (MSE) across", numFolds, "-fold cross-validation:", averageMSE, "\n")
cat("R-squared across", numFolds, "-fold cross-validation:", averageRSquared, "\n")

