---
title: "Getting and Cleaning Data"
output: html_document
---


#### importing the libraries
```{r}
# importing libraries
library(data.table)
library(reshape2)
```

#### get the working directory
```{r}
# store the working directory path
cur_path = getwd()
```


#### get the activity labels
```{r}
# read the text file activity_labels.txt
activity_labels <- fread(file.path(cur_path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("class_labels", "activity_names"))
activity_labels

```

#### get the features
```{r}
# store the features from features.txt
features <- fread(file.path(cur_path, "UCI HAR Dataset/features.txt"), col.names = c("index", "feature_names"))
features
```

#### get the index of interested features
```{r}
# store the index of features which are of interest
interested_features <- grep("(mean|std)\\(\\)", features[, feature_names])
interested_features
```

#### grab the features and remove the brackets
```{r}
# store interested features 
measurements <- features[interested_features, feature_names]
# remove the brackets from features and replace by ""
measurements <- gsub('[()]', '', measurements)
measurements
```

#### get the training data and chose only interested features
```{r}
# read the X_train.txt file 
x_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/X_train.txt"))
# get the data with the interested features only
x_train_interested <- x_train[, interested_features, with = FALSE]
head(x_train_interested)
```

#### set the column names equal to the measurements
```{r}
# change the column names to the names from measurements
setnames(x_train_interested, colnames(x_train_interested), measurements)
head(x_train_interested)
```

#### get activities, subject and bind them along with training data
```{r}
# load the Y_train.txt file with col name as activity
activities_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("activity"))
# load the subject_train.txt file with col name as subject_num
subject_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("subject_num"))
# bind the subject_train, activities_train and x_train_interested along the columns
x_train_interested <- cbind(subject_train, activities_train, x_train_interested)
head(x_train_interested)
```

#### follow the same steps for test data
```{r}
# read the X_test.txt file 
x_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/X_test.txt"))
# get the data with the interested features only
x_test_interested <- x_test[, interested_features, with = FALSE]
# change the column names to the names from measurements
setnames(x_test_interested, colnames(x_test_interested), measurements)
# load the Y_test.txt file with col name as activity
activities_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("activity"))
# load the subject_test.txt file with col name as subject_num
subject_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("subject_num"))
# bind the subject_test, activities_test and x_test_interested along the columns
x_test_interested <- cbind(subject_test, activities_test, x_test_interested)
head(x_test_interested)
```


#### merge train and test data
```{r}
# merge the both train and test data
merged <- rbind(x_train_interested, x_test_interested)
```


#### convert class labels to activity names
```{r}
# convert class labels to activity names
merged[["activity"]] <- factor(merged[, activity], levels = activity_labels[["class_labels"]], labels = activity_labels[["activity_names"]])
head(merged)
```


#### find the average of each variable
```{r}
# find the average of each variable
merged <- melt(data = merged, id = c("subject_num", "activity"))
merged <- dcast(data = merged, subject_num + activity ~ variable, fun.aggregate = mean)
head(merged)
```


#### write the dataset
```{r}
fwrite(x = merged, file = 'tidyData.txt', quote = FALSE)
```
