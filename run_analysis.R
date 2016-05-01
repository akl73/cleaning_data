library(data.table)
library(plyr)
library(dplyr)

# load_files from the website
if (!file.exists("./data")){dir.create("data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/human_activity.zip", method = "curl")

# unzip the files we are interested in
unzip("./data/human_activity.zip", files=c("UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/features.txt", 
                                           "UCI HAR Dataset/test/X_test.txt", "UCI HAR Dataset/test/y_test.txt" ,
                                           "UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt",
                                           "UCI HAR Dataset/test/subject_test.txt", "UCI HAR Dataset/train/subject_train.txt"),
                                    exdir = "./data")

# load files into data tables
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
activitiesDT <- data.table(activities)
setnames(activitiesDT, c("activityid", "activity"))
rm(activities)

features <- read.table("./data/UCI HAR Dataset/features.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
colnames <- features[, 2]
rm(features)

testData <- read.table("./data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE, stringsAsFactors = FALSE)
testDataDT <- data.table(testData)
rm(testData)

testActivities <- read.table("./data/UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
testActivitiesDT <- data.table(testActivities)
rm(testActivities)

testSubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
testSubjectsDT <- data.table(testSubjects)
rm(testSubjects)

trainData <- read.table("./data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
trainDataDT <- data.table(trainData)
rm(trainData)

trainActivities <- read.table("./data/UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
trainActivitiesDT <- data.table(trainActivities)
rm(trainActivities)

trainSubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
trainSubjectsDT <- data.table(trainSubjects)
rm(trainSubjects)

# add column names to x_test.txt and x_train.txt from features.txt
setnames(testDataDT, colnames)
setnames(trainDataDT, colnames)


# consolidate test data, activities and subjects
testDataDT[, activityid:= testActivitiesDT$V1]
testDataDT[, subjectid := testSubjectsDT$V1]

# consolidate train data, activities and subjects
trainDataDT[, activityid:= trainActivitiesDT$V1]
trainDataDT[, subjectid := trainSubjectsDT$V1]

# create one data table from train and test data
allDataDT <- tbl_df(rbind(testDataDT, trainDataDT))

# join activity labels 
allDataActivityDT <- join(allDataDT, activitiesDT)

# change subject into factor
allDataActivityDT$subjectid <- as.factor(allDataActivityDT$subjectid)

# extract only means and standard deviation plus activities and subjects
pattern <- "mean|std"
meansAndSd <- grepl(pattern,tolower(names(allDataActivityDT)))
meansAndSd[c(563, 564)] = TRUE # add activity and subjectid to the logical extractor vector
finalDataSet <- allDataActivityDT[, meansAndSd, with = FALSE]

# cleanup column names

names(finalDataSet) <- gsub("\\(|\\)|,|-", "", names(finalDataSet))
names(finalDataSet) <- gsub("^t", "time", names(finalDataSet))
names(finalDataSet) <- gsub("^f", "freq", names(finalDataSet))
names(finalDataSet) <- gsub("Acc", "acceleration", names(finalDataSet))
names(finalDataSet) <- gsub("Mag", "magnitude", names(finalDataSet))
names(finalDataSet) <- tolower(names(finalDataSet)) 
setcolorder(finalDataSet, c(length(finalDataSet), 1:(length(finalDataSet)-1))) # move subjectid as the first column
setcolorder(finalDataSet, c(length(finalDataSet), 1:(length(finalDataSet)-1))) # move activity as the first column
finalDataSet <- finalDataSet %>% arrange(activity, subjectid)

# create a summary data set

summaryData <- finalDataSet %>%
               group_by(activity, subjectid) %>%
               summarise_each(funs(mean)) %>%
               arrange(activity, subjectid)

# save summary data set

write.table(summaryData, file = "./data/activity_summary.txt", row.name = FALSE)
