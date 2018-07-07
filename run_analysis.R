##COURSE PROJECT
# Getting and Cleaning Data
#By Andre Caetano Luna

########
# header
library(dplyr)
library(readr)

setwd("/Users/andreluna/course_projects/getting_cleaning_data/UCI HAR Dataset")
########


## Reading feature and activity infos
ativity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

#Features has duplicated names, so I'll concatenate V1 and V2 to make unique identifiers
features$V3 <- paste0(features$V1,"_", features$V2)

### Reading training data
train_set <- read.table("./train/X_train.txt")
train_labels <- read.table("./train/Y_train.txt")
train_subject <- read.table("./train/subject_train.txt")


##Reading test data
test_set <- read.table("./test/X_test.txt")
test_labels <- read.table("./test/Y_test.txt")
test_subject <- read.table("./test/subject_test.txt")


#### Putting it all together
#Binding the sets
names(train_subject) <- "subject" ; names(test_subject) <-  "subject"
names(train_labels) <- "act1" ; names(test_labels) <- "act1"; names(ativity_labels) <- c("act1", "activity")

train_test <- rbind(train_set, test_set)
subjects <- rbind(train_subject, test_subject)
act_lables <- rbind(train_labels, test_labels)

#setting the right labels for activities
act_lables <-  act_lables %>% left_join(ativity_labels) %>% select(-act1)

#defining which features to extract
features$extract <-  grepl("^(.*)-mean|^(.*)-std"  , features$V3)

#naming the variables
names(train_test) <- features$V3 

#final bind
binded_full <- cbind(train_test, subjects, act_lables)


#### Extracting only mean and sd measures
to_extract <- features %>% filter(extract == T) %>% select(V3)
to_extract <- as.vector(to_extract$V3)


filtered_binded <- binded_full %>% select(to_extract, subject, activity)

#####Creating the tidy dataset
library(tidyr)


tidy <- filtered_binded  %>% gather("features", "values", 1:79) %>%
                              group_by(features, activity, subject) %>% 
                                summarise(average = mean(values)) %>%
                                  separate(features, into = c("index","features", "measure", "axis")) %>%
                                    select(-index)  

write.table(tidy, "tidy_dataset.txt", row.name = F)
