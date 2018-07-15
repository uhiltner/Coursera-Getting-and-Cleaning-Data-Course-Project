# Coursera-Getting-and-Cleaning-Data-Course-Project

This is the peer-graded assignment for the Getting and Cleaning Data Coursera course. The R script 'run_analysis.R' does the following:

  1. Loads or installs packages needed automatically
  
  2. Downloads the data from the internet if it does not already exist in the working directory
  
  3. Imports the data in two steps:
  
  3.1 Imports the activity and feature information
  
  3.2 Loads subsets of the training and test data, keeping only those columns which reflect a mean or standard deviation
  
  4. Merge the individual data sets to one dataset and adds lables
  
  5. Converts the 'activity' and 'subject' columns into factors
  
  6. Creates a second, independent tidy dataset with the mean of each variable for each activity and each subject.
  
  7. The result is written in the output file 'tidy.txt'.
