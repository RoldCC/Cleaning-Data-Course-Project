library(tidyverse)
library(data.table)
## Create the directory, download the zip file, unzip it and store it in the directory
link <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
wd <- "./info"
if(!file.exists(wd)){dir.create(wd)}
download.file(link,destfile = "./info/data.zip",method = "curl")
unzip("./info/data.zip",exdir = "./info")

##getting the data from the files .txt
docs_path <- file.path("./info","UCI HAR Dataset")
dtest_sub_test <- data.table::fread(file.path(docs_path,"test","subject_test.txt"))
dtest_x_test <- data.table::fread(file.path(docs_path,"test","X_test.txt"))
dtest_y_test <- data.table::fread(file.path(docs_path,"test","y_test.txt"))
dtrain_sub_train <- data.table::fread(file.path(docs_path,"train","subject_train.txt"))
dtrain_x_train <- data.table::fread(file.path(docs_path,"train","X_train.txt"))
dtrain_y_train <- data.table::fread(file.path(docs_path,"train","y_train.txt"))

dfeat <- data.table::fread(file.path(docs_path,"features.txt"))
da_labels <- data.table::fread(file.path(docs_path,"activity_labels.txt"))

##merging data
dsub <- rbind(dtrain_sub_train,dtest_sub_test)
dx <- rbind(dtrain_x_train,dtest_x_test)
dy <- rbind(dtrain_y_train,dtest_y_test)

##changing variables names
names(dy) <- c("activity")
names(dsub) <- c("subject")
names(dx) <- unlist(dfeat[,2])

##merging all data
data <- cbind(dx,dsub,dy)

##selecting only the mean and st needed
all_names <- names(data)
final_names <- grep("mean\\(\\)|std\\(\\)",all_names,value = T)
f_data <- select(data,c(final_names,"activity","subject"))
names(da_labels) <- c("id","activity")

##matching the activity names id from "da_labels" with the "activity" column in "f_data"
df <- merge(f_data,da_labels,by.x = "activity",by.y = "id")
df <- select(df,-activity)

##changing abbreviate names
abb <- c("^t","^f","Acc","Mag","BodyBody","Gyro")
rep <- c("time","frecuency","Accelerometer","Magnitude","Body","Gyroscope")
count <- 1
for (i in abb){
        names(df) <- gsub(i,rep[count],names(df))
        count <- count + 1
}
##mean for each variable and each activity 
DF <- aggregate(df,by = list(df$subject,df$activity.y),mean)
DF <- select(DF,c(-subject,-activity.y))
colnames(DF)[c(1,2)] <- c("activity","subject")
DF<-DF[order(DF$subject,DF$activity),]
write.table(DF, file = "tidydata.txt",row.name=FALSE)
