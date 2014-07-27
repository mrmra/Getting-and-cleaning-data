## For Coursera John Hopkins Data Science course, Getting and Cleaning Data
## assignment.

## ! Due to tight work schedule this week, may only complete the functional rough
##   draft of assignment without improvements.

## ! Automatic file downloading/unzipping left unimplemented for first pass.
## if(!file.exists("../UCI_HAR_Dataset")){dir.create("../UCI_HAR_Dataset")}
## fileUrl <- ""
## download.file(fileUrl,destfile="../UCI_HAR_Dataset/UCI.zip", method="curl")
## zip.unpack("UCI.zip", "./")

## First we load both data sets. We are going to have some unoptimized duplicated
## code here because we're keeping everything in separate files and then merging
## them all later, rather than doing a combined read/merge (! implement later).

train_subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt", sep="", col.names="Subject", stringsAsFactors=FALSE)
train_codes <- read.table("./UCI_HAR_Dataset/train/y_train.txt", sep="", col.names="Activity",stringsAsFactors=FALSE)
train_data <- read.table("./UCI_HAR_Dataset/train/x_train.txt", sep="\n", col.names="Data",stringsAsFactors=FALSE)
test_subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt", sep="", col.names="Subject",stringsAsFactors=FALSE)
test_codes <- read.table("./UCI_HAR_Dataset/test/y_test.txt", sep="", col.names="Activity",stringsAsFactors=FALSE)
test_data <- read.table("./UCI_HAR_Dataset/test/X_test.txt", sep="\n", col.names="Data",stringsAsFactors=FALSE)


## To change the ACTIVITY CODES into the names of the activities, we'll use
## the simple mapping function sapply() with a fast SWITCH statement.

swap <- train_codes$Activity 
swapped <- sapply(swap, function(val) switch(val, '1'="WALKING", 
                                                  '2'="WALKING_UPSTAIRS",
                                                  '3'="WALKING_DOWNSTAIRS",
                                                  '4'="SITTING",
                                                  '5'="STANDING",
                                                  '6'="LAYING",
                                                  'UNK'))
train_codes$Activity <- swapped

## And we do it again for the other data set. This would be better as a function()
## so we don't call the same code twice. (! implement later)

swap <- test_codes$Activity 
swapped <- sapply(swap, function(val) switch(val, '1'="WALKING", 
                                             '2'="WALKING_UPSTAIRS",
                                             '3'="WALKING_DOWNSTAIRS",
                                             '4'="SITTING",
                                             '5'="STANDING",
                                             '6'="LAYING",
                                             'UNK'))
test_codes$Activity <- swapped

## Next we need to filter out the data on "mean" and "std" (standard deviation).
## To do this, we'll first read in the "features" data file and filter it through a 
## regular expression to return a data frame with our selection. Could also use
## a Boolean filter with straight grepl(), but this filter will allow us to 
## also generate the column names we want. 

features <- read.table("./UCI_HAR_Dataset/features.txt", sep="", 
                       col.names=c("Position","Name"), stringsAsFactors=FALSE)
featuresFilter <- features[grep("(?=mean)|(?=std)", features$Name, perl=TRUE),]

## Now we need to take each row of the data sets, unlist it so we can access it
## by index, and build our new data frame with just the mean and std.

trained_data <- data.frame()

for(row in 1:nrow(train_data)){
    filterMe <- train_data[row,1]
    filterMe2 <- strsplit(filterMe, " ", perl=TRUE)
    filterMe3 <- unlist(filterMe2)
    filterMe4 <- as.numeric(filterMe3)
    filterMe5 <- na.omit(filterMe4)
    ## ^^ There is undoubtedly a better way to filter. The string split causes
    ##    some blanks -- better regexp would cure this (! implement), but as it 
    ##    is, we can easily convert to numeric and then remove the blanks/NAs.
    
    for(i in 1:nrow(featuresFilter)){
        columnName <- featuresFilter[i,'Name']
        ordinal <- featuresFilter[i,'Position']
        trained_data[row,columnName] <- filterMe5[ordinal]
    }
}

## And again, for the other data set. I know, we should make functions. For later
## updates.

tested_data <- data.frame()

for(row in 1:nrow(test_data)){
    filterMe <- test_data[row,1]
    filterMe2 <- strsplit(filterMe, " ", perl=TRUE)
    filterMe3 <- unlist(filterMe2)
    filterMe4 <- as.numeric(filterMe3)
    filterMe5 <- na.omit(filterMe4)
    ## ^^ There is undoubtedly a better way to filter. The string split causes
    ##    some blanks -- better regexp would cure this (! implement), but as it 
    ##    is, we can easily convert to numeric and then remove the blanks/NAs.
    
    for(i in 1:nrow(featuresFilter)){
        columnName <- featuresFilter[i,'Name']
        ordinal <- featuresFilter[i,'Position']
        tested_data[row,columnName] <- filterMe5[ordinal]
    }
}

## Well, now we have our data, we really need to MERGE it into one data.frame.
## We will start by zipping up the test and train sets separately.

test_final <- test_subject
test_final <- cbind(test_final, test_codes)
test_final <- cbind(test_final, tested_data)

train_final <- train_subject
train_final <- cbind(train_final, train_codes)
train_final <- cbind(train_final, trained_data)

## Finally, bind test_final and train_final w/o losing data, and order by Subject
## and Activity to zip results together

final_data <- rbind(train_final, test_final)
final_data <- final_data[with(final_data, order(Subject, Activity)),]

## Let's have a quick peek at the merged product.

head(final_data,n=4)
summary(final_data)
str(final_data)

## And export.

write.csv(final_data, file="Clean_HAR_data.csv")


## Lots of optimizing to go back and do here, and column names could be better,
## but that's the data set!