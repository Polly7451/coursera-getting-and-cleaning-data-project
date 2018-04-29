setwd("C:/Users/polly.halton/Documents/Coursera/Cleaning_data/Week_4_Assignment/Assiginment")

## Unzip the file


filename <- "GetData_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}


# read in the features and activity lables 

ActLabs <- read.table("UCI HAR Dataset/activity_labels.txt")
ActLabs[,2] <- as.character(ActLabs[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# find the feature names that mention mean or standard deviation


MeanSD <- grep(".*mean.*|.*std.*", features[,2])



# read train dataset and pull all parts together

trainX <- read.table("UCI HAR Dataset/train/X_train.txt")[MeanSD]
trainAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubs <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubs, trainAct, trainX)

dim(train)
names(train)



# read the test dataset and pull all parts together

testY <- read.table("UCI HAR Dataset/test/X_test.txt")[MeanSD]
testAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubs <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubs, testAct, testY)

dim(test)

# merge datasets
allData <- rbind(train, test)


#have a quick look
dim(allData)
head(allDate)
str(allData)


# add names and lables

MeanSD.names <- features[MeanSD,2]
MeanSD.names <- gsub('-mean', 'Mean', MeanSD.names)
MeanSD.names <- gsub('-std', 'StandardDev', MeanSD.names)
MeanSD.names <- gsub('[-()]', '', MeanSD.names)


colnames(allData) <- c("Subject", "Activity", MeanSD.names)


# make activities and subjects to class of factor

library(reshape2)


allData$Activity <- factor(allData$Activity, levels = ActLabs[,1], 
                           labels = ActLabs[,2])
allData$Subject <- as.factor(allData$Subject)




allData.melted <- melt(allData, id = c("Subject", "Activity"))
allData.mean <- dcast(allData.melted, Subject + Activity ~ variable, mean)

View(allData.mean)

write.table(allData.mean, "TidyWearableTech.txt", row.names = FALSE)

