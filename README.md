## Repository for Getting & Cleaning Data John Hopkins Data Science Coursera Course

### 
  * Assignment is to create a tidy data set from this data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
  * Comments in code, but generally:
  * The data set was mined for individual tables which then had common names substituted for various activity codes;
  * Data set further broken apart to identify the mean and standard deviation of various axial movements of the holder of a cellular phone during the activities;
  * Data was merged into a final data set, identifying each individual subject (phone user), activity engaged in, and axial motions mean/standard deviation.
  * To replicate, download data and unzip into directory: UCI_HAR_Dataset (the default unzip directory), then run script.  
  * Script generates output CSV file "Clean_HAR_data.csv" in your working directory.
  
## For more on the data set, see: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
