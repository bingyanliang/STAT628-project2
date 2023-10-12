# Summary on data cleaned
This is a markdown file for notes about how we cleaned the data

- Initial rows: 252
- Rows with missing values removed: 10
- Duplicate rows removed: 0
- Outlier rows removed: 10
- Final rows after cleaning: 242

I used Z-score method to identify and remove outliners.

The Z-score method is a statistical technique used to identify and remove outliers from a dataset. It quantifies how far away each data point is from the mean (average) of the dataset in terms of standard deviations. 

Here's how it works:
- Calculate the mean (μ) and standard deviation (σ) of the dataset.
- For each data point (x) in the dataset, calculate its Z-score using the following formula:
- Z-score (Z) = (x - μ) / σ

A Z-score measures how many standard deviations a data point is away from the mean. Typically, values with Z-scores greater than a certain threshold (e.g., 2 or 3) are considered outliers. You can adjust this threshold based on your data and requirements.

Data points with Z-scores exceeding the chosen threshold are identified as outliers and can be removed from the dataset.
By using Z-scores to identify outliers, you can objectively determine which data points deviate significantly from the mean. This method is widely used for outlier detection because it is based on the distribution of the data itself.
