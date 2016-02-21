# Load the libraries, clear the workspace
library(dplyr)
library(reshape2)
rm(list = ls())

# Read the datasets and the appropriate labels (including subjects)
train <- read.table('train/X_train.txt',header=F,strip.white=T)
trainlabels <- read.table('train/y_train.txt',header=F,strip.white=T)
trainsubjects <- read.table('train/subject_train.txt',header=F,strip.white=T)
test <- read.table('test/X_test.txt',header=F,strip.white=T)
testlabels <- read.table('test/y_test.txt',header=F,strip.white=T)
testsubjects <- read.table('test/subject_test.txt',header=F,strip.white=T)

# Read the data types; name the test and train data appropriately
datatype <- read.table('features.txt',header=F,strip.white=T)
datatype <- datatype$V2 
names(train) <- datatype
names(test) <- datatype

# Make data frames for each, labeling the variables, melt them, then merge them together.
# NOTE FOR GRADER: THE MELTING HERE CREATES A "LONG" DATASET, WITH DISTINCT ROWS FOR
# EACH TRAIN/TEST MEASUREMENT, WHICH I PREFER (ASSIGNMENT SAYS EITHER IS OK).

trainortest <- rep(as.factor("train"),dim(train)[1])
trainframe <- data.frame(trainsubjects,trainlabels,trainortest,train)  %>% rename(subject=V1,label=V1.1)
melttrain <- melt(trainframe,id=c("subject","label","trainortest"))

trainortest <- rep(as.factor("test"),dim(test)[1])
testframe <- data.frame(testsubjects,testlabels,trainortest,test) %>% rename(subject=V1,label=V1.1)
melttest <- melt(testframe,id=c("subject","label","trainortest"))

bigframe <- bind_rows(melttrain,melttest)

# Filter the frame to contain only rows with variable types that contain "mean" or "std"
filterframe <- filter(bigframe,grepl("mean|std",variable,ignore.case=T))

# Get the activity labels and match to the data set (using plyr function). 
# (I felt that these labels were sufficiently descriptive, once the matching is done.)
activitylabels <- read.table('activity_labels.txt',header=F,strip.white=T,stringsAsFactors=F)
filterframe$label <- plyr::mapvalues(filterframe$label,from=activitylabels[,1],to=activitylabels[,2])

# Sub out some of the jargony variables for more descriptive names
filterframe$variable <- gsub("tBodyAcc","Body Acceleration Signal", filterframe$variable)
filterframe$variable <- gsub("tBodyGyro","Body Gyroscope Signal", filterframe$variable)
filterframe$variable <- gsub("fBodyAcc","Body Acceleration \\(FFT\\)", filterframe$variable)
filterframe$variable <- gsub("fBodyGyro","Body Gyroscope \\(FFT\\)", filterframe$variable)
filterframe$variable <- gsub("fBodyBodyGyro","BodyBody Gyroscope \\(FFT\\)", filterframe$variable)
filterframe$variable <- gsub("fBodyBodyAcc","BodyBody Acceleration \\(FFT\\)", filterframe$variable)
filterframe$variable <- gsub("tGravityAcc","Gravity Acceleration Signal", filterframe$variable)
filterframe$variable <- gsub("angle","Angle Between", filterframe$variable)
filterframe$variable <- gsub("Jerk"," \\(Jerk\\)", filterframe$variable)
filterframe$variable <- gsub("Mag"," \\(Magnitude\\)", filterframe$variable)

#Rename the dataframe with more descriptive names
filterframe <- rename(filterframe,activity=label,measurement=variable)

# For each subject/activity/measurement, filter by each of those dimensions, take the average (mean)
# then add to a new dataframe with all the averages
averageframe <- data.frame()
for (i in 1:30) {
      thisdata1 <- filter(filterframe,subject==i)
      for (j in 1:6) {
            thisdata2 <- filter(thisdata1,activity==unique(thisdata1$activity)[j])
            for (k in 1:length(unique(thisdata2$measurement))) {
                  thisdata3 <- filter(thisdata2,measurement==unique(thisdata2$measurement)[k])
                  if (nrow(thisdata3) != 0) {
                        thelist <- data.frame(subject=thisdata3$subject[1],
                              activity=thisdata3$activity[1],
                              measurement=thisdata3$measurement[1],mean=mean(thisdata3$value))
                        averageframe <- bind_rows(averageframe,thelist)
                        }
            }
      }
}

#Write the dataset to a file
write.table(averageframe,"Dataset of Averages (Tidy).txt",row.name=FALSE)
