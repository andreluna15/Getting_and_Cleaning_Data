---
title: "ReadMe"
author: "Andre Luna"
date: "7/6/2018"
output: html_document
---

# Getting and Cleaning Data Course Project

## Project Description
This is the course project for Getting and Cleaning Data, part of the Data Science specialization on John Hopkins University. The objective of the project is to treat messy data and deliver a tidy dataset, containing the average value of each feature, for each individual in each activity. In this Codebook you will see the description of the raw data, the treatment process and the resulting tidy dataset. The course project is also a way to evaluate my skills in creating a complete Codebook and ReadMe file for a complete description of the analysis process, and the organization of a GitHub repository.

The present file is intended to explicit each step in collecting, cleaning and processing the raw data to transform it into a tidy dataset. A more complete explanation of variables, of the raw data and its original authors can be found in the [Codebook file]<https://github.com/dehzao/Getting_and_Cleaning_Data/blob/master/Codebook.md>

## Creating the tidy datafile

### Guide to create the tidy data file

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

#### 1 - Download Data
The data was downloaded manually , using the link provided by the course. The data can be downloaded using this [link]<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

#### 2 - Loading data into R
Once downloaded, the data was allocated in the working directory, defined as
```{r eval = F}
setwd("/Users/andreluna/course_projects/getting_cleaning_data/UCI HAR Dataset")
```

Before loading and treating the data, three libraries were required:
```{r eval = F}
library(dplyr)
library(readr)
library(tidyr)
```

Than, data were loaded in three waves. The first loading wave included only the label information:
```{r eval = F}
## Reading feature and activity infos
ativity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
```

The second, all the train data:
```{r eval = F}
### Reading training data
train_set <- read.table("./train/X_train.txt")
train_labels <- read.table("./train/Y_train.txt")
train_subject <- read.table("./train/subject_train.txt")
```

At last, all the test data:
```{r eval = F}
##Reading test data
test_set <- read.table("./test/X_test.txt")
test_labels <- read.table("./test/Y_test.txt")
test_subject <- read.table("./test/subject_test.txt")
```

#### 3 - Fixing duplicated feature names
The *features* object was composed of V1 - index and V2 - names of the 561 features. Still V2 was not composed by unique names, which would later on lead to merging issues. To fix this issue, a simple concatenation of index and name was conducted, creating a V3 column in the object:
```{r eval = F}
#Features has duplicated names, so I'll concatenate V1 and V2 to make unique identifiers
features$V3 <- paste0(features$V1,"_", features$V2)
```

#### 4 - Merging train and test data + 5 - Label data
As all datasets were organized by rows, a simples row bind is sufficient to effectively merge train and test data, as long as the merge of the feature data, subject and label data obeys the order of train and test merge. But first, it is necessary to change the generic variable names (V1, V2, V3...) to avoid name conflicts when merging by columns later:
```{r eval = F}
#### Putting it all together
#Binding the sets

names(train_subject) <- "subject" ; names(test_subject) <-  "subject"
names(train_labels) <- "act1" ; names(test_labels) <- "act1"; names(ativity_labels) <- c("act1", "activity")


train_test <- rbind(train_set, test_set)
subjects <- rbind(train_subject, test_subject)
act_lables <- rbind(train_labels, test_labels)
```

Once they are pilled up, I can simply column-bind them together. But first, it is important to apply the unique feature names to train and test data, for furhter feature extraction:
```{r eval = F}
#naming the variables
names(train_test) <- features$V3 

#final bind
binded_full <- cbind(train_test, subjects, act_lables)
```

#### 6 - Extracting desired features (mean and sd)
In order to extract only the features regarding mean and standard deviation measurements, I must set a Regular Expression that captures all the cases:
```{r eval = F}
features$extract <-  grepl("^(.*)-mean|^(.*)-std"  , features$V3)
```

With the code above I created a new logical colum in *features*, assigning **TRUE** to all value that matched the expression. Than I filter the *features* dataset and extract a vector of feature names that matched the conditions, called "to_extract":

```{r eval = F}
#### Extracting only mean and sd measures
to_extract <- features %>% filter(extract == T) %>% select(V3)
to_extract <- as.vector(to_extract$V3)
```

With the vector, and the other two id variables - activity and subject - I can select only the variables of interest, composing the intended dataset, ready for reshaping and tyding:

```{r eval = F}
filtered_binded <- binded_full %>% select(to_extract, subject, activity)
```

#### 7 to 11 - Tyding the dataset
This section compiles the final treatment steps:
7. Reshaping dataset to Long
8. Grouping by key variables
9. Summarising by the average of measures
10. Creating axis and measure information
11. Cleaning undesirable information


The compilation is intended, once each step is a line of the following pipe code:
```{r eval = F}
tidy <- filtered_binded  %>% 
          gather("features", "values", 1:79) %>% #Step 7 Reshaping
            group_by(features, activity, subject) %>% #Step 8 Grouping
              summarise(average = mean(values)) %>% #Step 9 Summarising
                separate(features, into = c("index","features", "measure", "axis")) %>% 
  #Step 10 Creating axis and measurement information
                  select(-index)  #Step 11 Cleaning

```

On Step 7, the gather function breaks all feature names, previously organized in columns, into values of a single column, called *features*. Their row values were assigned to a *values* variable. This command turned the dataset from a Wide format to a Long one.

On Step 8, the dataset was grouped by the variables of interest: features, activity and subject, enabling easy calculation of the average values.

On Step 9, the average value of features, per subject, per activity was calculated using summarise

As the feature values were still composed by Measure informations (mean and sd) Axis information (X, Y and Z), and a residual index prefix, I used separate to break the feature column into 4 new ones: 
* index: containing the residual idnex prefix to be further eliminated
* features: containing the pure feature name
* measure: containing the mean and sd indicator
* axis: containing the axis indicator (X, Y, Z or NA)

Finally, on Step 11, the residual index column was eliminated using the select function

#### 12 - Creating tidy_data.txt
Once the dataset was adjusted to have only one variable per column, and only one type of measurement on each row, the tidy data set was finally created using the following command:

```{r eval = F}
write.table(tidy, "tidy_dataset.txt", row.name = F)
```

