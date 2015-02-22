## Getting and Cleaning Data Project

### Source Data
A full description of the data can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for the project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Data Set Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information
For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### run_analysis.R details
### Section 1. Merge the training and the test sets to create one data set.
The data set contains 2 sets in seperate folders, a test data set and a training set.
Each data set contains 3 files
- x_*.txt   		(contains the readings/features for each test)
- y_*.txt			(contains the activity codes for each test)
- subject_*.txt		(contains the subject ID for each test)

In addition, 2 additional files identify the feature labels and the activity type
- features.txt			(provides the label for the columns in the x_*.txt files)
- activity_labels.txt	(provides the a description of the activity codes used in the y_*.txt files)

The code create a 'tidy' training and test data set by
1. taking the x data and labelling them based on the features data
2. creating an activity vector based on the y data and column binding it with step 1
3. creating a subject vector based on the subject data and column binding it with step 2

At this stage we have a data frame for the training data.
The data no longer needed is removed to free up memory...
The same steps are repeated to create a test data set. Ideally the process of creating the 2 data sets 
would be a function.
Finally the 2 data sets created are row binded to create a data set 'tidySet'

## Section 2. Extract only the measurements on the mean and standard deviation for each measurement. 
The column names are extracted and a logical vector created using the grepl to return true for the variables desired.
This logical vector is then used to select only the desired columns in tidySet.

## Section 3. Use descriptive activity names to name the activities in the data set
In this step we want to take the human readable activity names (activity_labels.txt) 
and merge them with the todySet created. Using the mege command a new column 'Avtivity.Description' is
added with the appropriate human readable activity type description.
The new column is initially placed at the end of the data frame, the last step moves this column to the start of the 
data frame to make it easier to read.

## Section 4. Appropriately label the data set with descriptive activity names.
In this section the original column labels are replaced with comething more readable.
Here we should include units, but I could not find the appropriate units for all readings.
4.1 Replace mean with Mean and std with StdDev to make the data look tidy
4.2 Replace tBodyAcc with (t) Body Acceleration
4.3 Replace tGravityAcc with (t) Gravity Acceleration
4.4 Replace tBodyGyro with (t) Body Gyro
4.5 Replace fBodyAcc with (f) Body Acceleration
4.6 Replace fGravityAcc with (f) Gravity Acceleration
4.7 Replace fBodyGyro with (f) Body Gyro
4.8 Replace fBodyBodyAcc with (f) Body Acceleration + JerkMag with Jerk Mag 
4.9 Replace fBodyBodyGyro with (f) Body Gyro + JerkMag with Jerk Mag 


## Section 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
The final dataset tidy is created using the aggregate command, where the data is aggregated by 'activity' and then by 'Subject'.
An alternative would be to aggregate by 'Subject' and then by 'Activity'. This is included at the end of the script