# Step 1: Set the working directory
setwd("~/Downloads")  

# Step 2: Load feature names and clean them
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("Index", "FeatureName"))
feature_names <- make.names(features$FeatureName, unique = TRUE)
feature_names

# Step 3: Load activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "ActivityName"))
activity_labels

# Step 4: Load training data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature_names)

# Step 5: Load test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature_names)

# Step 6: Merge subject, activity, and features for train and test sets
train_data <- cbind(subject_train, y_train, X_train)
test_data <- cbind(subject_test, y_test, X_test)

# Step 7: Merge training and test datasets
full_data <- rbind(train_data, test_data)

#Step 8: Extract only where means and sd appear
grep("mean|std",names(full_data))

#Step 9: Change the activity names
full_data$Activity <- factor(full_data$Activity,
                      levels = c(1, 2, 3, 4,5,6),
                      labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                                 "SITTING", "STANDING", "LAYING"))

#Step 10: Change the variable names to make them more readable
col_names<-names(full_data)
col_names<-gsub("^t","Time",col_names)
col_names<-gsub("^f","Frequency",col_names)
col_names<-gsub("Acc","Accelerometer",col_names)
col_names<-gsub("Gyro","Gyroscope",col_names)
col_names<-gsub("Mag","Magnitude",col_names)
col_names<-gsub("^f","Fast Fourier Transform ",col_names)
col_names<-gsub("BodyBody","Body",col_names)
col_names <- gsub("\\.mean\\.\\.", "Mean", col_names)
col_names <- gsub("\\.std\\.\\.", "STD", col_names)
col_names <- gsub("\\.+", "", col_names)

names(full_data)<-col_names

#Step 10: Create the new tidy data frame
library(dplyr)
tidy_data<-full_data%>%
  group_by(Subject,Activity) %>%
  summarise(across(everything(), mean), .groups = "drop")
tidy_data
write.table(tidy_data, row.names = FALSE)
