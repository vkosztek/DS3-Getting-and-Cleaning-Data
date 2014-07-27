# instructions to get the tidy data set from the raw data set found under this 
# address: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# checks working directory, returns boolean.
checkDirectory <- function() {
        dirAddress <- getwd()
        isDir <- substr(dirAddress, (nchar(dirAddress) - nchar("candtData") + 1), nchar(dirAddress))
        print(isDir)
        if(isDir == "candtData") {
                return(TRUE)
        } else {
                return(FALSE)
        }
}

# sets (and if "candtData" directory does not exist, creates) working directory, 
setDirectory <- function(){
        if(file.exists("candtData")) {
                setwd("./candtData")
        } else if(!checkDirectory()) {
                dir.create("candtData")
                setwd("./candtData")
        }
}

# download zip from source then unzip it
# "The time of my download is " "Sat Jun 21 21:09:39 2014"
getZip <- function() {
        setDirectory()
        
        
        if(!file.exists("dataset.zip")) {
                zipUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                
                download.file(zipUrl, "dataset.zip")
                dateDownloaded <- as.character(date())
                print(c("The time of the download is ",dateDownloaded))       
                zipFile <- "dataset.zip"
                unzip(zipFile, overwrite = FALSE)
        }
}


getXData <- function() {
        features <- "./UCI HAR Dataset/features.txt"
        colNames <- read.table(features, colClasses = "character")[, 2]
        
        means <- grep(".mean.", colNames)
        stds <- grep(".std.", colNames)
        neededVariables <- sort(c(means, stds))
        
        x_train <- "./UCI HAR Dataset/train/X_train.txt"
        x_test <- "./UCI HAR Dataset/test/X_test.txt"
        
        xTrain <<- read.table(x_train, , col.names = colNames)[,neededVariables]
        xTest <<- read.table(x_test, col.names = colNames)[,neededVariables]
                
}

changeActivityLabels <- function(yData) {
        act <- read.table("./UCI HAR Dataset/activity_labels.txt")
                
        
        for(x in 1:length(act[, 1])) {
                
                yData[, 1] <- gsub(act[x, 1], act[x, 2], yData[, 1])
                
        }
      
}

getYData <- function() {
        y_train <- "./UCI HAR Dataset/train/y_train.txt"
        y_test <- "./UCI HAR Dataset/test/y_test.txt"
        
        yTrain <- read.table(y_train, col.names = "ActivityLabels")
        yTest <- read.table(y_test, col.names = "ActivityLabels")
        
        yTrain <<- changeActivityLabels(yTrain)
        yTest <<- changeActivityLabels(yTest)
        
}
        
mergeXYData <- function() {
        train <<- cbind(yTrain, xTrain)
        test <<- cbind(yTest, xTest)
        
}

mergeSubjectData <- function() {
        subject_train <- "./UCI HAR Dataset/train/subject_train.txt"
        subject_test <- "./UCI HAR Dataset/test/subject_test.txt"
        
        subjectTrain <- read.table(subject_train, col.names="Subject")
        subjectTest <- read.table(subject_test, col.names="Subject")
        
        train <<- cbind(subjectTrain, train)
        test <<- cbind(subjectTest, test)
        
}


# read relevant datas from the original dataset and merge training data with test data
getDataset <- function() {
        getZip()
        
        #get xTrain and xTest data tables
        getXData()
        
        #get activity labels for xTrain and xTest
        getYData()
        
        
        #merge the activity labels with xTrain and xTest
        mergeXYData()
        
        
        #merge subject labels to train and test
        mergeSubjectData()
        
        #merge train and test tables
        tidyData <<- rbind(train, test)
        
        #return(tidyData)
}


getSecondData <-function(firstData) {
        secondData <- firstData[order(firstData[, 1], firstData[, 2]), ]
        
        idVars <- names(tidyData)[1:2]
        moltedData <- melt(secondData, id.vars=idVars)
        castedData <- acast(moltedData, variable ~ ActivityLabels ~ Subject, mean)
        
        write.table(castedData, "tidyData.txt")
        
}


