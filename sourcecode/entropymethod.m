% Read the CSV file into a table
data = readtable('C:/Users/preet/Downloads/cleaned_bodyfat2.csv');

% Extract the desired columns
selectedColumns = {'AGE', 'WEIGHT', 'HEIGHT', 'ADIPOSITY', 'NECK', 'CHEST', 'ABDOMEN', 'HIP', 'THIGH', 'KNEE', 'ANKLE', 'BICEPS', 'FOREARM', 'WRIST'};
selectedData = data(:, selectedColumns);

% Extract the target variable (BODYFAT)
target = data.BODYFAT;

% Build a decision tree model using entropy as the split criterion
model = fitctree(selectedData, target, 'SplitCriterion', 'deviance');

% Get feature importance
importance = predictorImportance(model);

% Sort it
[~,featureIdxSortbyImportance] = sort(importance,'descend');

% Get top 2 features
top2predictors = selectedColumns(featureIdxSortbyImportance(1:2));

% Display the selected features
fprintf('Selected Features:\n');
disp(top2predictors);

% Create a new data matrix with the selected features
selectedData = selectedData(:, top2predictors);

% Build a decision tree using the selected features
tree = fitctree(selectedData, target);

% Visualize the decision tree (optional)
view(tree, 'Mode', 'graph');

% Add these lines after building the decision tree model
numFolds = 5; % You can change this to the number of folds you want to use

% Perform k-fold cross-validation
cv = cvpartition(height(data), 'KFold', numFolds);
mseValues = zeros(numFolds, 1);

for fold = 1:numFolds
    trainData = selectedData(cv.training(fold), :);
    trainTarget = target(cv.training(fold));
    testData = selectedData(cv.test(fold), :);
    testTarget = target(cv.test(fold));
    
    tree = fitctree(trainData, trainTarget);
    predictions = predict(tree, testData);
    
    % Calculate the Mean Squared Error for this fold
    mseValues(fold) = mean((testTarget - predictions).^2);
end

% Calculate the average MSE across all folds
averageMSE = mean(mseValues);

fprintf('Mean Squared Error (MSE) across %d-fold cross-validation: %f\n', numFolds, averageMSE);
