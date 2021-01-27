require(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="auto")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
combined<- cbind(Subject, Y, X)

FormattedData <- combined %>% select(subject, code, contains("mean"), contains("std"))
FormattedData$code <- activities[FormattedData$code, 2]

names(combined)[2] = "activity"
names(combined)<-gsub("Acc", "Accelerometer", names(combined))
names(combined)<-gsub("Gyro", "Gyroscope", names(combined))
names(combined)<-gsub("BodyBody", "Body", names(combined))
names(combined)<-gsub("Mag", "Magnitude", names(combined))
names(combined)<-gsub("^t", "Time", names(combined))
names(combined)<-gsub("^f", "Frequency", names(combined))
names(combined)<-gsub("tBody", "TimeBody", names(combined))
names(combined)<-gsub("-mean()", "Mean", names(combined), ignore.case = TRUE)
names(combined)<-gsub("-std()", "STD", names(combined), ignore.case = TRUE)
names(combined)<-gsub("-freq()", "Frequency", names(combined), ignore.case = TRUE)
names(combined)<-gsub("angle", "Angle", names(combined))
names(combined)<-gsub("gravity", "Gravity", names(combined))

FinalData <- combined %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

str(FinalData)
