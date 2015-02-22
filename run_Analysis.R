# run_Analysis.R
# John Hopkins 'Getting and Cleaning Data' Project assignment

# 1   --- Merges the training and the test sets to create one data set
setwd("~/R/JohnHopkins/Getting and Cleaning Data/Project")               # Set the working directory so we can read the data

# Get the features (col names) & activity codes
features = read.table('./UCI HAR Dataset/features.txt',header=FALSE);             # read the features file
activityType = read.table('./UCI HAR Dataset/activity_labels.txt',header=FALSE);  # read the activity codes


# Training Data ==================================================================================================
X_train       = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE);           # load the x (features)
Y_train       = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE);           # load the y (activity codes)
subject_train = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE);     # load the subject codes 

# Create a 'tidy' table for the training data - trainingData
trainingData <- X_train
colnames(trainingData) <- features$V2             #1.1 Rename the columns of the X_train data to match the features

activity <- Y_train                               #1.2 create a new vector activity which is the same as the Y_train table
colnames(activity) <- "Activity.Code"             # Change the column name to be 'Activity Code'
trainingData <- cbind(activity, trainingData)     # Column bind it with the training data so that the activity code is the first column

subject <- subject_train                          #1.3 create a new vector subject which contains the subject ID
colnames(subject) <- "Subject.ID"                 # change the column title     
trainingData <- cbind(subject, trainingData)      # Column bind it with the training data

# remove all temp variables used to free memory
rm(activity)
rm(subject)
rm(X_train)
rm(Y_train)
rm(subject_train)
# Now we should have a clean data table trainingData that conttains all the relevant training data


# Repeat for the Test Data ========================================================================================
X_test       = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE);           
Y_test       = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE);           
subject_test = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE);   

# Create a 'tidy' table for the test data - testData
testData <- X_test
colnames(testData) <- features$V2                 

activity <- Y_test                               
colnames(activity) <- "Activity.Code"           
testData <- cbind(activity, testData)     

subject <- subject_test                          
colnames(subject) <- "Subject.ID"                     
testData <- cbind(subject, testData)      

# remove all temp variables used
rm(activity)
rm(subject)
rm(X_test)
rm(Y_test)
rm(subject_test)

# Now we have a tidy data table that conttains all the relevant training data
# so lets row bind them toghether
tidySet <- rbind(trainingData, testData)
rm(trainingData)
rm(testData)


#2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#2.1 find the column names in the tidySet that contains mean and stdDev
columnNames <- colnames(tidySet)
# using grepl create a logic vector identifing all the columns that contain mean() or std()
desiredColumns <- grepl("Subject.ID", columnNames, fixed=TRUE) | grepl("Activity.Code", columnNames, fixed=TRUE) | grepl("mean()", columnNames, fixed=TRUE) | grepl("std()", columnNames, fixed=TRUE) 
# now use this logic vector to only select the columns we want
tidySet <- tidySet[desiredColumns==TRUE];
rm(columnNames)
rm(desiredColumns)


#3 Uses descriptive activity names to name the activities in the data set
#  Rename the columns in the activityType table so we can merge with the data already extracted
colnames(activityType)  <- c('Activity.Code','Activity.Description');
# merge themby the shared feature 'Activity.Code'
tidySet <- merge(tidySet, activityType, by='Activity.Code', all.x=TRUE);
# Move the 'Activity Description' feature/column to the start of the data frame
# makes it easier to read
tidySet <- tidySet[,c("Activity.Description",setdiff(names(tidySet),"Activity.Description"))]


#4 Appropriately labels the data set with descriptive variable names.
# 4.1 Replace mean with Mean and std with StdDev to make the data look tidy
# 4.2 Replace tBodyAcc with (t) Body Acceleration
# 4.3 Replace tGravityAcc with (t) Gravity Acceleration
# 4.4 Replace tBodyGyro with (t) Body Gyro
# 4.5 Replace fBodyAcc with (f) Body Acceleration
# 4.6 Replace fGravityAcc with (f) Gravity Acceleration
# 4.7 Replace fBodyGyro with (f) Body Gyro
# 4.8 Replace fBodyBodyAcc with (f) Body Acceleration + JerkMag with Jerk Mag 
# 4.9 Replace fBodyBodyGyro with (f) Body Gyro + JerkMag with Jerk Mag 
columnNames <- colnames(tidySet)
columnNames <- gsub('-mean', " Mean ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('-std' , " StdDev ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('[()-]', " ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('tBodyAcc', " (t) Body Acceleration ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('tGravityAcc', " (t) Gravity Acceleration ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('tBodyGyro', " (t) Body Gyro ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('fBodyAcc', " (f) Body Acceleration ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('fGravityAcc', " (f) Gravity Acceleration ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('fBodyGyro', " (f) Body Gyro ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('fBodyBodyAcc', " (f) Body Acceleration ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('fBodyBodyGyro', " (f) Body Gyro ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
columnNames <- gsub('JerkMag', "Jerk Mag ", columnNames, ignore.case = TRUE, perl = FALSE, fixed = FALSE, useBytes = FALSE)
colnames(tidySet) = columnNames



#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# set the description and subject as factors
tidySet$Activity.Description <- as.factor(tidySet$Activity.Description)
tidySet$Subject.ID <- as.factor(tidySet$Subject.ID)
# create a new table that mean aggregates the data by activity and then by subject
tidy = aggregate(tidySet, by=list(Activity = tidySet$Activity.Description, Subject = tidySet$Subject.ID), mean)
# delete these columns as they are no longer useful
tidy$Activity.Description = NULL
tidy$Activity.Code = NULL
tidy$Subject.ID = NULL


write.table(tidy, './tidyData.txt',row.names=TRUE,sep='\t');



# End - this is not required for the project ======================================
# if the data is required in the oppostie fashion (which may be more intuitive for plotting to visualise the difference between activities)
# swap the order of the list
tidy2 = aggregate(tidySet, by=list(Subject = tidySet$Subject.ID, Activity = tidySet$Activity.Description), mean)
# delete these columns as they are no longer useful
tidy2$Activity.Description = NULL
tidy2$Activity.Code = NULL
tidy2$Subject.ID = NULL

# plot the data
plot(tidy2[,2], tidy2[,3])           # Activity vs  (t)Body Acceleration  Mean X
plot(tidy[,2], tidy[,3])             # Subject  vs  (t)Body Acceleration  Mean X

