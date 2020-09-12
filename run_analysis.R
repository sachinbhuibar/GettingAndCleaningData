# importing libraries
library(data.table)
library(reshape2)

cur_path = getwd()

# get activity labels + features
activity_labels <- fread(file.path(cur_path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("class_labels", "activity_names"))
features <- fread(file.path(cur_path, "UCI HAR Dataset/features.txt"), col.names = c("index", "feature_names"))
interested_features <- grep("(mean|std)\\(\\)", features[, feature_names])
measurements <- features[interested_features, feature_names]
measurements <- gsub('[()]', '', measurements)


# get training data
x_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/X_train.txt"))
x_train_interested <- x_train[, interested_features, with = FALSE]
setnames(x_train_interested, colnames(x_train_interested), measurements)
activities_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("activity"))
subject_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("subject_num"))
x_train_interested <- cbind(subject_train, activities_train, x_train_interested)


# get test data
x_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/X_test.txt"))
x_test_interested <- x_test[, interested_features, with = FALSE]
setnames(x_test_interested, colnames(x_test_interested), measurements)
activities_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("activity"))
subject_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("subject_num"))
x_test_interested <- cbind(subject_test, activities_test, x_test_interested)



# merge data
merged <- rbind(x_train_interested, x_test_interested)


# convert class labels to activity name 
merged[["activity"]] <- factor(merged[, activity], levels = activity_labels[["class_labels"]], labels = activity_labels[["activity_names"]])


# find the average of each variable
merged <- melt(data = merged, id = c("subject_num", "activity"))
merged <- dcast(data = merged, subject_num + activity ~ variable, fun.aggregate = mean)

View(merged)

# write the dataset
fwrite(x = merged, file = 'tidyData.txt', quote = FALSE)


