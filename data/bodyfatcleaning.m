 % Load the data from the CSV file
data = readtable('bodyfat.csv');

% Check for missing values
missing_values = sum(ismissing(data));
fprintf('Missing Values:\n');
disp(missing_values);

% Remove rows with missing values
data_cleaned = data(~any(ismissing(data), 2), :);

% Check for duplicates
duplicate_rows = data_cleaned(ismember(data_cleaned, data_cleaned, 'rows'), :);
fprintf('Duplicate Rows:\n');
disp(duplicate_rows);

% Remove duplicate rows
data_cleaned = unique(data_cleaned);

% Detect and handle outliers (you can customize this part based on your data)
% Example: Z-score method for detecting and removing outliers
z_scores = zscore(data_cleaned{:, 2:end});
outlier_rows = any(abs(z_scores) > 3, 2);  % Adjust the threshold as needed
fprintf('Outlier Rows:\n');
disp(data_cleaned(outlier_rows, :));
data_cleaned(outlier_rows, :) = [];  % Remove outlier rows

% Check for other data quality issues (e.g., inconsistent or invalid values)
% Example: You can add additional checks here based on your specific data

% Save the cleaned data to a new CSV file if needed
writetable(data_cleaned, 'cleaned_bodyfat.csv');

% Display a message indicating the number of rows removed
fprintf('Data Cleaning Summary:\n');
fprintf('Initial rows: %d\n', size(data, 1));
fprintf('Rows with missing values removed: %d\n', size(data, 1) - size(data_cleaned, 1));
fprintf('Duplicate rows removed: %d\n', size(data_cleaned, 1) - size(unique(data_cleaned), 1));
fprintf('Outlier rows removed: %d\n', sum(outlier_rows));
fprintf('Final rows after cleaning: %d\n', size(data_cleaned, 1));
