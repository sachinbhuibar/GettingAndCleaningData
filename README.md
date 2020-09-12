# GettingAndCleaningData

### Please go through CodeBook.pdf file which has code and output altogether
### files included in the repository
1. run_analysis.R ->  R code file
2. CodeBook.md -> markdown file with R code
3. CodeBook.pdf -> pdf file which is obtained after knit to pdf command
4. tidyData.txt -> data after processing 

### Tasks to be done
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Program flow
1. importing the libraries
2. get the working directory
3. get the activity labels
4. get the features
5. get the index of interested features
6. grab the features and remove the brackets
7. get the training data and chose only interested features
8. set the column names equal to the measurements
9. get activities, subject and bind them along with training data
10. follow the same steps for test data
11. merge train and test data
12. convert class labels to activity name
13. find the average of each variable
14. write the dataset

### tasks completed with program flow
task 1 -> 11
task 2 -> 2 to 10
task 3 -> 12
task 4 -> 8 and 10
task 5 -> 13 and 14
