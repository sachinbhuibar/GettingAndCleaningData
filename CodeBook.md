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
cur_path = getwd()
```


#### get the activity labels
```{r}

# get activity labels + features
activity_labels <- fread(file.path(cur_path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("class_labels", "activity_names"))
activity_labels

```

#### get the features
```{r}
features <- fread(file.path(cur_path, "UCI HAR Dataset/features.txt"), col.names = c("index", "feature_names"))
features
```

#### get the index of interested features
```{r}
interested_features <- grep("(mean|std)\\(\\)", features[, feature_names])
interested_features
```

#### grab the features and remove the brackets
```{r}
measurements <- features[interested_features, feature_names]
measurements <- gsub('[()]', '', measurements)
measurements
```

#### get the training data and chose only interested features
```{r}
x_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/X_train.txt"))
x_train_interested <- x_train[, interested_features, with = FALSE]
head(x_train_interested)
```

#### set the column names equal to the measurements
```{r}
setnames(x_train_interested, colnames(x_train_interested), measurements)
head(x_train_interested)
```

#### get activities, subject and bind them along with training data
```{r}
activities_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("activity"))
subject_train <- fread(file.path(cur_path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("subject_num"))
x_train_interested <- cbind(subject_train, activities_train, x_train_interested)
head(x_train_interested)
```

#### follow the same steps for test data
```{r}
x_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/X_test.txt"))
x_test_interested <- x_test[, interested_features, with = FALSE]
setnames(x_test_interested, colnames(x_test_interested), measurements)
activities_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("activity"))
subject_test <- fread(file.path(cur_path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("subject_num"))
x_test_interested <- cbind(subject_test, activities_test, x_test_interested)
head(x_test_interested)
```


#### merge train and test data
```{r}
merged <- rbind(x_train_interested, x_test_interested)
```


#### convert class labels to activity name
```{r}
merged[["activity"]] <- factor(merged[, activity], levels = activity_labels[["class_labels"]], labels = activity_labels[["activity_names"]])
head(merged)
```


#### find the average of each variable
```{r}
merged <- melt(data = merged, id = c("subject_num", "activity"))
merged <- dcast(data = merged, subject_num + activity ~ variable, fun.aggregate = mean)
head(merged)
```


#### write the dataset
```{r}
fwrite(x = merged, file = 'tidyData.txt', quote = FALSE)
```
