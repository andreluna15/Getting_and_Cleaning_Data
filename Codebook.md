---
title: "Project CodeBook"
author: "Andre Luna"
date: "7/6/2018"
output: 
  html_document:
    keep_md: yes
---

## Project Description
This is the course project for Getting and Cleaning Data, part of the Data Science specialization on John Hopkins University. The objective of the project is to treat messy data and deliver a tidy dataset, containing the average value of each feature, for each individual in each activity. In this Codebook you will see the description of the raw data, the treatment process and the resulting tidy dataset. The course project is also a way to evaluate my skills in creating a complete Codebook and ReadMe file for a complete description of the analysis process, and the organization of a GitHub repository.

##Study design and data processing

###Collection of the raw data
The data was made available in the course assingment page, through the [download link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The dataset was collected by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto and Xavier Parra, from 
>"(...) 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."

The volunteers were between the age of 19 and 48. Each performed six activities using a Samsung Galaxy S II on their waist. The data on the activities was captured using the phones' accelerometer and gyroscope, collecting 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets named train and test sets. Further information on the raw data can be accessed on the [UCI Machine Learning Repository page](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

For academic referencing, please use the following citation:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

###Raw data structural description
The following text is a quote from the original README file in the experiment data:

>The dataset includes the following files:

>* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

>The following files are available for the train and test data. Their descriptions are equivalent. 

> 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

> 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

> 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

> 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. "


##Creating the tidy datafile

###Guide to create the tidy data file

1. Download data
2. Load data into R
3. Fixing duplicated feature names
4. Merging train and test data
5. Label data
6. Extracting desired features (mean and sd)
7. Reshaping dataset to Long
8. Grouping by key variables
9. Summarising by the average of measures
10. Creating axis and measure information
11. Cleaning undesirable information
12. Creating tidy_data.txt

###Cleaning of the data
The cleaning process starts with ensuring unique feature names to avoid future merging problems. For that, the feature names were concatenated with their indexes. After that, the train and test dataset were merged by rows, as they are well ordered. The same process was conductd to merge subject and activity data for both train and test. Once they are merged by row, features, subjects and activity data were merged by column. The lables contained in the feature.txt and activity_info.txt files were applied to the resulting dataset. Only the features related to mean and standard deviation measures were extracted to composed the final data set prior to the tidy data. The dataset was reshaped, turning the feature columns into row values of a variable called "features". After grouping by features, activities and subjects, the average value of the measures was calculated. At last, the feature axis and measurement (mean and sd) information were broken into columns, resulting in a tidy dataset. At last, a leftover "index" column is eliminated, as it has no use. For further detail on the code and cleaning steps of the data, please click on the [link to the README document](https://github.com/dehzao/Getting_and_Cleaning_Data/blob/master/README.md)

##Description of the variables in the tiny_data.txt file
The resulting tidy dataset is comprised of 6 variables and 14220 observations. The variables are as follows:

* features: feature name collected by the phone's sensor
    + t: stands for "time domain signals"
    + f: when a Fast Fourier Transform (FFT) was applied to the signal
    + Body/Gravity: acceleration signals separated into body and gravity acceleration signals
    + Acc/Gyr: data from the Accelerometer sensor or from the Gyroscope sensor
    + Jerk: body linear acceleration and angular velocity derived in time to obtain Jerk signals
    + Mag: calculation of magnitude of signal using Euclidian norm
* measures: the mean or standard deviation measure from features calculated in the raw data  
* activity: the 6 activities captured in the experient, being:
    + WALKING
    + WALKING_UPSTAIRS
    + WALKING_DOWNSTAIRS
    + SITTING
    + STANDING
    + LAYING
* subject: the subject index, ranging from 1 to 30
* average: average measurement of each individual, in each activity, collected by each feature

Below, a summary of the variables:


```r
link <- "https://raw.githubusercontent.com/dehzao/Getting_and_Cleaning_Data/master/tidy_dataset.txt"

download.file(link, "./tidy_dataset.txt")

tidy <- read.table("./tidy_dataset.txt", header = T, sep = "")

print(summary(tidy))
```

```
##          features        measure     axis                   activity   
##  fBodyAcc    :1620   mean    :5940    :3960   LAYING            :2370  
##  fBodyAccJerk:1620   meanFreq:2340   X:3420   SITTING           :2370  
##  fBodyGyro   :1620   std     :5940   Y:3420   STANDING          :2370  
##  tBodyAcc    :1080                   Z:3420   WALKING           :2370  
##  tBodyAccJerk:1080                            WALKING_DOWNSTAIRS:2370  
##  tBodyGyro   :1080                            WALKING_UPSTAIRS  :2370  
##  (Other)     :6120                                                     
##     subject        average        
##  Min.   : 1.0   Min.   :-0.99767  
##  1st Qu.: 8.0   1st Qu.:-0.95242  
##  Median :15.5   Median :-0.34232  
##  Mean   :15.5   Mean   :-0.41241  
##  3rd Qu.:23.0   3rd Qu.:-0.03654  
##  Max.   :30.0   Max.   : 0.97451  
## 
```
