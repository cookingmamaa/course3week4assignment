library(tidyverse)

setwd(choose.dir()) #choose directory that contains the UCI HAR Dataset folder

#Importing the data

#Training Data

training_data_set <- read.table("UCI HAR Dataset/train/X_train.txt")
training_data_labels <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE,
                                 sep = ' ')
training_data_subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE,
                                 sep = ' ')-

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

#Features 
features_labels <- read.csv("UCI HAR Dataset/features.txt", header = FALSE, sep = ' ')
features_labels <- as.character(features_labels[,2])


#1 Merges the training and test sets to create one data sets 

#Combining the training and test data into one data frame
combined_data <- rbind(training_data, test_data)

#Renaming the columns
names(combined_data) <- c(c("subject_id", "activity"), features_labels)


#2 Extracts only the measurements on the mean and 
#Standard Deviation for each measurement
mean_std_measurements <- grep('mean|std', features_labels)

combined_data_mean_std <- combined_data[,c(1,2,(mean_std_measurements+2))]


#3 Uses descriptive activity names to name the activies in the data set
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",
                            header = FALSE, sep = ' ')

activity_labels <- as.character(activity_labels[,2])

combined_data_labeled <- combined_data_mean_std

#using the activity_labels to rename activity numbers to proper descriptions
combined_data_labeled$activity <- activity_labels[combined_data_labeled$activity]


#4 Appropriately labels the data set columns with descriptive variable names
names_descriptions <- names(combined_data_labeled)
names_descriptions <- gsub("Acc", "Acceleration", names_descriptions)
names_descriptions <- gsub("Gyro", "Gyroscope", names_descriptions)
names_descriptions <- gsub("Freq", "Frequency", names_descriptions)
names_descriptions <- gsub("Mag", "Magnitude", names_descriptions)
names_descriptions <- gsub("^t", "Time", names_descriptions)
names_descriptions <- gsub("^f", "Frequency", names_descriptions)

names(combined_data_labeled) <- names_descriptions


#5 From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject

combined_data_tidy <- combined_data_labeled %>%
    gather('TimeBodyAcceleration-mean()-X':'FrequencyBodyBodyGyroscopeJerkMagnitude-meanFrequency()',
           key = "Metric", value = "value") %>%
    group_by(subject_id, activity, Metric) %>%
    summarise(average = mean(value))

#Exporting the data to a tidydata.txt file
write.table(combined_data_tidy, "tidydata.txt")
