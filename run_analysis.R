
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


if(!file.exists("data")){dir.create("data")}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Project.zip")
Project <-unzip ("./data/Project.zip")

#Read Activity labels

Act_Label <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#Read column names

feature <- read.table("./UCI HAR Dataset/features.txt")[,2]

#Get only mean and Standard Deviation of the measurements 

get_feature <- grepl("mean|std", feature)

#Load and process test data

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(Xtest) = feature

#Get only mean and Standard Deviation of the measurements 
Xtest = Xtest[, get_feature]

#Read activity labels

Ytest[,2] = Act_Label[Ytest[,1]]
names(Ytest) = c("Activity_ID","Activity_Label")
names(Subtest) = "subject"

#Combine the data
Testdata <- cbind(as.data.table(Subtest),Ytest,Xtest)

#Do the same for the train data
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")

Subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = feature

Xtrain = Xtrain[, get_feature]

Ytrain[,2] = Act_Label[Ytrain[,1]]
names(Ytrain) = c("Activity_ID","Activity_Label")
names(Subtrain) = "subject"

TrainData <- cbind(as.data.table(Subtrain), Ytrain, Xtrain)

#Merge the train and test data
Merge = rbind(Testdata, TrainData, fill = TRUE)

IdLabel <- c("subject","Activity_ID","Activity_Label")
DataLabel <- setdiff(colnames(Merge), IdLabel)
Melt = melt(Merge, id = IdLabel, measure.vars = DataLabel)

#Calculate Mean of the values in the data
TidyData = dcast(Melt, subject + Activity_Label ~ variable, mean)

#Create the final table using Write.Table function

write.table(TidyData, file = "./TidyData.txt")





