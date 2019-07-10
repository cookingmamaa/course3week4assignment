The Assignment
==============

Quoted from Coursera:

You should create one R script called run\_analysis.R that does the
following.

1.  Merges the training and the test sets to create one data set.

2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.

3.  Uses descriptive activity names to name the activities in the data
    set

4.  Appropriately labels the data set with descriptive variable names.

5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

The Data (taken from README.txt)
--------------------------------

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

The dataset includes the following files:
-----------------------------------------

-   ‘README.txt’

-   ‘features\_info.txt’: Shows information about the variables used on
    the feature vector.

-   ‘features.txt’: List of all features.

-   ‘activity\_labels.txt’: Links the class labels with their activity
    name.

-   ‘train/X\_train.txt’: Training set.

-   ‘train/y\_train.txt’: Training labels.

-   ‘test/X\_test.txt’: Test set.

-   ‘test/y\_test.txt’: Test labels.

Packages Utilized
-----------------

    library(tidyverse)

Step 1) Importing the training and test data and making one data frame from each
--------------------------------------------------------------------------------

    #Training Data

    training_data_set <- read.table("UCI HAR Dataset/train/X_train.txt")
    training_data_labels <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE,
                                     sep = ' ')
    training_data_subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE,
                                     sep = ' ')
                                     
    #Combining the training data into one data frame

    training_data <- data.frame(training_data_subject, training_data_labels,
                                training_data_set) 
                                

    #Test data

    test_data_set <- read.table("UCI HAR Dataset/test/X_test.txt")

    test_data_labels <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE,
                                     sep = ' ')

    test_data_subject <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE,
                                      sep = ' ')

    #Combining the test data into one data frame

    test_data <- data.frame(test_data_subject, test_data_labels, test_data_set)
                                     

Step 2) Importing the features.txt file to provide names for the metrics
------------------------------------------------------------------------

    #Features 
    features_labels <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = ' ')
    features_labels <- as.character(features_labels[,2])

Step 3) Combining the training and test data into one data frame
----------------------------------------------------------------

    combined_data <- rbind(training_data, test_data)

Step 4) Renaming the columns
----------------------------

    names(combined_data) <- c(c("subject_id", "activity"), features_labels)

Step 5) Extracts only the measurements on the mean and standard Deviation for each measurement
----------------------------------------------------------------------------------------------

    mean_std_measurements <- grep('mean|std', features_labels)

    combined_data_mean_std <- combined_data[,c(1,2,(mean_std_measurements+2))]

Step 6) Importing the activity labels and renaming the activity column with correct names
-----------------------------------------------------------------------------------------

    activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",
                                header = FALSE, sep = ' ')

    activity_labels <- as.character(activity_labels[,2])

    combined_data_labeled <- combined_data_mean_std

    combined_data_labeled$activity <- activity_labels[combined_data_labeled$activity]

Step 7) Appropriately labels the data set columns with descriptive variable names
---------------------------------------------------------------------------------

    names_descriptions <- names(combined_data_labeled)
    names_descriptions <- gsub("Acc", "Acceleration", names_descriptions)
    names_descriptions <- gsub("Gyro", "Gyroscope", names_descriptions)
    names_descriptions <- gsub("Freq", "Frequency", names_descriptions)
    names_descriptions <- gsub("Mag", "Magnitude", names_descriptions)
    names_descriptions <- gsub("^t", "Time", names_descriptions)
    names_descriptions <- gsub("^f", "Frequency", names_descriptions)

    names(combined_data_labeled) <- names_descriptions

Step 8) From the data set in the previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject
----------------------------------------------------------------------------------------------------------------------------------------------------------------

    combined_data_tidy <- combined_data_labeled %>%
        gather('TimeBodyAcceleration-mean()-X':'FrequencyBodyBodyGyroscopeJerkMagnitude-meanFrequency()',
               key = "Metric", value = "value") %>%
        group_by(subject_id, activity, Metric) %>%
        summarise(average = mean(value))
        

Step 9) Exporting the data to “tidydata.txt”
--------------------------------------------

    write.table(combined_data_tidy, "tidydata.txt", row.name = FALSE)
