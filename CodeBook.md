Transformation + Work done for run_analysis.r

1) Imported the training and test data files (X_train/test, y_train/test, subject_train/test)
2) Imported the features.txt file which provides names for all the metrics
3) Combined the respective three training and test files into one data frame each for test and training
4) Performed a row bind (rbind() ) operation to combine the training and test data
5) Renamed the columns in our new data frame with subject_id, activity, and then the remaining labels from the features.txt file
6) Extracted the names of the metrics that had either the mean or standard deviation through the grep() function
7) Created a new data frame by keeping subject_id and activity and then passing the metrics we extracted that just measure mean and standard deviation
8) Imported the activity_labels.txt file and renamed the activity column in the data frame to have proper descriptions match the respective values for these descriptions
9) Renamed multiple columns in the data frame to be slightly more descriptive
10) Created a tidy data set by using the gather() function to put all the metrics into one column to then calculate the mean value based on grouping of subject, activity, and metrics
11) Extracted this tidy data set with write.table() and named it "tidydata.txt"
