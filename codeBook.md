The script 'run_analysis.R' performs the steps described in the course project's definition 
(https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project) and the 'README.md' file.
It generates a new dataset with all the mean measures for each subject and activity type (30 subjects * 6 activities = 180 rows). 
The output file is called 'tidy.txt', and uploaded to this repository.

Functions:

	The function 'packages_needed()' checks for missing packages and loads or installs them automatically. 
	It takes one argument x, which is a character vector, holding package names.


Variables

	trainSub, trainAct, trainX, testSub, testAct, and testX contain the data from the downloaded files.
    dataAll holds the merged data of the previous datasets for further analysis.
    features contains the correct names for the dataAll dataset, which are applied to the column names stored in featuresNeeded.names, a character vector used to extract the desired data.
    A similar approach is taken with activity labels through the activityLabels variable.
    Finally, dataAll.mean contains the relevant averages which will be later stored in tidy.txt file. melt() and dcast() from the reshape2 package is used to apply means() and ease the development.
