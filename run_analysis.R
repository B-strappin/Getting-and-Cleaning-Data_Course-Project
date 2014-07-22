## Check if variables have already been set, in order to save load
## time. If not, create temporary file to hold zip file map. Unzip
## files and read into variables for processing.
library(data.table)
if(!exists("X_test") | !exists("X_train") | !exists("subject_test") | !exists("subject_train") | !exists("features")){
    temp <- tempfile()
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp, method = "curl")
    featurefile <- unz(temp, "UCI HAR Dataset/features.txt")
    testfile <- unz(temp, "UCI HAR Dataset/test/X_test.txt")
    testsubfile <- unz(temp, "UCI HAR Dataset/test/subject_test.txt")
    trainfile <- unz(temp, "UCI HAR Dataset/train/X_train.txt")
    trainsubfile <- unz(temp, "UCI HAR Dataset/train/subject_train.txt")
    features <- read.csv(featurefile,header=FALSE, sep="")
    X_test <- read.csv(testfile,header=FALSE, sep="")
    subject_test <- read.csv(testsubfile, header=FALSE)
    X_train <- read.csv(trainfile, header=FALSE, sep="")
    subject_train <- read.csv(trainsubfile, header=FALSE)
    unlink(temp)
}

## Add names to test and train data
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]
colnames(subject_test) <- "subject"
colnames(subject_train) <- "subject"

## add subject number with train and test data
X_train$subject <- subject_train$subject
X_test$subject <- subject_test$subject

## Part 1.)
## Merge the training and test sets to create one data set
train.test.data <- rbind(X_train,X_test)

## Part 2.)
## Extract only measurements on the mean and standard deviation
train.test.mean.std <- subset(train.test.data, select=(names(train.test.data)[grep('mean|std|subject',names(train.test.data))]))

## Part 3.)
## Uses descriptive activity names to name the activities in the data set
## This section was completed prior to the merger of the two original datasets
## for my personal simplicity.

## Part 4.)
## Add descriptive variable names to dataset
## I am using CamelCase because lower case is just too hard to read :)
names(train.test.mean.std) <- sub('^tBody|^tBodyBody','TimeDomainSignalofBody',names(train.test.mean.std))
names(train.test.mean.std) <- sub('^fBody|^fBodyBody','FastFourierTransform',names(train.test.mean.std))
names(train.test.mean.std) <- sub('^tGravity','TimeDomainSignalofGravity',names(train.test.mean.std))
names(train.test.mean.std) <- sub('Acc','Acceleration',names(train.test.mean.std))
names(train.test.mean.std) <- sub('Jerk','JerkSignal',names(train.test.mean.std))
names(train.test.mean.std) <- sub('Gyro','Gyroscope',names(train.test.mean.std))
names(train.test.mean.std) <- sub('Mag','Magnitude',names(train.test.mean.std))
names(train.test.mean.std) <- sub('mean\\(\\)','MeanValue',names(train.test.mean.std))
names(train.test.mean.std) <- sub('std\\(\\)','StandardDeviation',names(train.test.mean.std))
names(train.test.mean.std) <- sub('meanFreq\\(\\)','WeightedAverageOfFrequency',names(train.test.mean.std))

## Part 5.)
library(reshape2)
melted.data <- melt(train.test.mean.std, id="subject")
subject.avgs <- dcast(melted.data, subject ~ variable, mean)
## Write out dataset to current working directory as .csv file
write.csv(subject.avgs, file = "Part5_dataset.csv")