## Getting and Cleaning Data Project
### Overview
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis
[The source data for the project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Assumptions
The analysis R script assumes the raw data is placed in a sub-folder named 'UCI HAR Dataset'.
Lines 8,9,13,14,15,39,40,41 which load the data assume this.
The code is run under RStudio 0.98.1091 using R-version 'Pumpkin Helmet' (3.1.2)

### Project Summary
You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Additional Information
Information about the data set can be found in the CodeBook