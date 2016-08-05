getwd()
setwd ("C:/Users/jdullum/Documents/Training/Coursera_CleaningData/Week4/")

install.packages(reshape2)
library(reshape2) 

smartphone <- "getdata_dataset.zip" 

## Download dataset: 
if (!file.exists(smartphone)){ 
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip " 
        download.file(fileURL, smartphone, mode='wb') 
        }   
if (!file.exists("UCI HAR Dataset")) {  
        unzip(smartphone)  
        } 
# Load labels and activity from the dataset
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 
activity_labels[,2] <- as.character(activity_labels[,2]) 
activity_labels
features <- read.table("UCI HAR Dataset/features.txt") 
features[,2] <- as.character(features[,2]) 
features

# getting the mean and sd 
featuresWanted <- grep(".*mean.*|.*std.*", features[,2]) 
featuresWanted
featuresWanted.names <- features[featuresWanted,2] 
featuresWanted.names

featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names) 
featuresWanted.names
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)  
featuresWanted.names

#Training and Testing Datasets 
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresWanted] 
train
trainlabels <- read.table("./UCI HAR Dataset/train/Y_train.txt") 
trainlabels
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainSubjects
train <- cbind(trainSubjects, trainlabels, train) 

test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featuresWanted] 
test
testlabels <- read.table("./UCI HAR Dataset/test/Y_test.txt") 
testlabels
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testSubjects
test <- cbind(testSubjects, testlabels, test) 
test

# merge datasets and add labels 
install.packages(plyr)
install.packages(tidyr)


allData <- rbind(train, test) 
allData
colnames(allData) <- c("subject", "activity", featuresWanted.names) 

 # turn activities & subjects into factors 
allData$activity <- factor(allData$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
allData$subject <- as.factor(allData$subject) 


allData.melted <- reshape2:::melt(allData, c("subject", "activity")) 
allData.mean <- reshape2:::dcast(allData.melted, subject + activity ~ variable, mean) 

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE) 


