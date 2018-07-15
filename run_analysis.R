## File:
#   run_analysis.R
#
## Notes:
#   Using data collected from the accelerometers from the Samsung Galaxy S 
#   smartphone, work with the data and make a clean data set, outputting the
#   resulting tidy data to a file named "tidy_data.txt".
#   See README.md for details.

## 1. Loads or installs packages needed automatically----

# The function 'packages_needed()' checks for missing packages 
# and loads / installs them automatically. 
# It takes one argument x: character vector, holding package names.
packages_needed <- function(x){
  # For each element in character vector ...
  for(i in x){
    # Try to load package:'require()' returns TRUE invisibly if it was able to.
    if(!require(i , character.only = TRUE) ){
      # If package was not able to be loaded then install it.
      install.packages(i, dependencies = TRUE)
      #  Load package after installing. 
      # 'library()' will throw an exception if the install wasn't successful.
      library(i, character.only = TRUE ) 
    } 
  } 
}

# Function call
packagesUsed <- c("tidyverse", "reshape2")
packages_needed(packagesUsed) 

## 2. Download data from the internet----
##    if it does not already exist in the working directory

# Checking for data and/or download
filename.zip <-  "./data_week4/Dataset.zip"
if(!file.exists(filename)){
  # create directory
  dir.create("./data_week4")
  # download
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile = filename.zip)
  # Keep track of the data versionisation
  dateDownloaded <- lubridate::now() 
}
# Checking for unzipped data and/or unzip
filename.unzip <- "./data_week4/UCI HAR Dataset"
if (!file.exists(filename.unzip)) { 
  # Extract data
  unzip(zipfile = filename, exdir = "./data_Week4")
}

## 3. Import the data in 2 steps----
# Using the relative path to the working directory
wd <- getwd()
# Assign folder name of data sets within the working directory
dataPathTrain <- paste0(wd, "/data_Week4/UCI HAR Dataset/train/")
dataPathTest <- paste0(wd, "/data_Week4/UCI HAR Dataset/test/")
dataPathMeta <- paste0(wd, "/data_Week4/UCI HAR Dataset/")

## 3.1 Import data description and activity labels----
features <- read.table(paste0(dataPathMeta, "features.txt"))
features[,2] <- as.character(features[,2])

activityLabels <- read.table(paste0(dataPathMeta, "activity_labels.txt"))
activityLabels[,2] <- as.character(activityLabels[,2])
colnames(activityLabels) <- c("activityId", "activityLabel")

## 3.2 Load subsets of the training and test data----
# Extract only the data on mean and standard deviation
featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])
featuresNeeded.names <- features[featuresNeeded,2]
featuresNeeded.names = gsub('-mean', 'Mean', featuresNeeded.names)
featuresNeeded.names = gsub('-std', 'Std', featuresNeeded.names)
featuresNeeded.names <- gsub('[-()]', '', featuresNeeded.names)

# Import train data
trainX <- read.table(paste0(dataPathTrain, "X_train.txt"))[featuresNeeded]
trainAct <- read.table(paste0(dataPathTrain, "Y_train.txt"))
trainSub <- read.table(paste0(dataPathTrain, "subject_train.txt"))

#  Import test data
testX <- read.table(paste0(dataPathTest, "X_test.txt"))[featuresNeeded]
testAct <- read.table(paste0(dataPathTest, "Y_test.txt"))
testSub <- read.table(paste0(dataPathTest, "subject_test.txt"))

## 4. Merge the individual data sets and add lables----
dataAll <- rbind(
  cbind(trainSub, trainAct, trainX),
  cbind(testSub, testAct, testX)
)
colnames(dataAll) <- c("subject", "activity", featuresNeeded.names)

# Remove individual data tables to save memory
rm(trainSub, trainX, trainAct, testSub, testX, testAct)

## 5. Facotize activities and subjects----
dataAll$activity <- factor(dataAll$activity, 
                           levels = activityLabels[,1], 
                           labels = activityLabels[,2])
dataAll$subject <- as.factor(dataAll$subject)

## 6. Creates a second, independent tidy data set with the mean of each variable 
# for each activity and each subject.
dataAll.long <- reshape2::melt(dataAll, id = c("subject", "activity"))
dataAll.mean <- reshape2::dcast(dataAll.long, subject + activity ~ variable, mean)

## 7. Output of tidy data----
write.table(dataAll.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
