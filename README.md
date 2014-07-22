Getting and Cleaning Data: Course Project
========================================

## Downloading and Processing Activity Data

The raw activity data, variable names and documentation are spread out between multiple folders and files. 

The objective of this assignment was to create a process that accessed these files from the original zip file and turned the data into something that is useful for eventually extracting patterns or various bits of knowledge about the subjects involved.

## Access Data
The data is accessed through the cloudfront link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A temp file is created that holds a map to the zip file contents. The temp file is then used to separately unzip each file we want to use prior to reading into variables.

## Add activity name variables
This is supposed to be part 3 of the assignment, but it simply made more sense to me to do it at this point. The way in which this was accomplished was to download the "features.txt" data and set colnames to the second column's values from "features.txt".

## Part 1.) Merge datasets
Merge both the test and train datasets to account for all subjects' data. This part was simple with the rbind() function.

## Part 2.) Extract only measurements on the mean and standard deviation
In order to keep only the mean and standard deviation columns, we used the subset() function along with a simple grep command to keep all columns that matched the representing regular expressions.

## Part 3.) Use descriptive acitivity names
As mentioned before, this part was completed prior to merging the datasets for my own simplicity.

## Part 4.) Add descriptive variable names
This section is a bit laborious. The sub() function was implemented many times to replace column name patterns with their more easily understandable representations.

## Part 5.) Create tidy dataset of averages of the data for each subject
For the final part of the project, the reshape2 package needed to be loaded. The melt() function was used to create the variable components for use of the dcast() function. The dcast() function created