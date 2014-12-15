### This R script called run_analysis.R does the following: 
# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for 
##  each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive activity names. 
# 5 Creates a second, independent tidy data set with the average of each 
##  variable for each activity and each subject. 

setwd("~/Desktop/Getting and cleaning Data")
# Read the test and train dataset
#Getting and cleaning Data/UCI HAR Dataset-2/test
test_x_data <- read.table("./UCI HAR Dataset-2/test/X_test.txt", header = FALSE)
train_x_data <- read.table("./UCI HAR Dataset-2/train/X_train.txt", header = FALSE)

# Read the test and training labels
test_y_data <- read.table("./UCI HAR Dataset-2/test/y_test.txt", header = FALSE)
train_y_data <- read.table("./UCI HAR Dataset-2/train/y_train.txt", header = FALSE)

# Read the test and training subjects who performed the activity
test_subject_data <- read.table("./UCI HAR Dataset-2/test/subject_test.txt", header = FALSE)
train_subject_data <- read.table("./UCI HAR Dataset-2/train/subject_train.txt", header = FALSE)

# Merge the test and train dataset
nrow(test_x_data)
nrow(train_x_data)
x_data <- rbind(test_x_data, train_x_data, deparse.level = 0)
nrow(x_data)
head(x_data)

# Merge the test and train labels
nrow(test_y_data)
nrow(train_y_data)
y_data <- rbind(test_y_data, train_y_data, deparse.level = 0)
nrow(y_data)

# Merge the the test and training subjects who performed the activity
nrow(test_subject_data)
nrow(train_subject_data)
subject_data <- rbind(test_subject_data, train_subject_data, deparse.level = 0)
nrow(subject_data)


#   Extracts only the measurements on the mean and standard deviation for 
##  each measurement. 
features <- read.table("./UCI HAR Dataset-2/features.txt") # you can find the names of the variables here
# take indices when the pattern of mean or sd is found with grep
index <- grep("-mean\\(\\)|-std\\(\\)", features[,2], ignore.case = TRUE,invert = FALSE)
print(index)
feat_mean_std <- features[index,]
head (feat_mean_std)
tail (feat_mean_std)
##feat_mean_std
nrow(feat_mean_std)
#
x_data_mean <-sapply(x_data, mean, na.rm=TRUE)
x_data_sd <-sapply(x_data,sd,na.rm=TRUE)
length(x_data_mean)
length(x_data_sd)

# use the index for the data
x_mean_std_data <- x_data[index,]
head(x_mean_std_data)
nrow(x_mean_std_data)

# Uses descriptive activity names to name the activities in the data set
activity <- read.table("./UCI HAR Dataset-2/activity_labels.txt")
head(activity)
head(y_data)
y_data[,2] <- activity[y_data[,1],2]
tail(y_data)
colnames(y_data) <- c("activity_code", "activity")


# Appropriately labels the data set with descriptive activity names. 
head(subject_data)

colnames(subject_data)<- "subject"

new <- cbind(subject_data, y_data, x_data)
head(new)
nrow(new)


#  Creates a second, independent tidy data set with the average of each 
##  variable for each activity and each subject
## there are 30 subjects and 6 activities, so there can be max 180 rows

new <- new[order(new$subject, new$activity_code),]

library(plyr)
tidy<-aggregate(. ~subject + activity, new, mean)
tidy<-tidy[order(tidy$subject,tidy$activity_code),]
nrow(tidy)


write.table(tidy, file = "tidydata.txt",row.name=FALSE)
