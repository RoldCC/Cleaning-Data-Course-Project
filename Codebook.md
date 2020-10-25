# Data introduction
The project is about extract, work and clean data, all this from different files that are in one dataset called "URI HAR Dataset", those files are:  

* activity_labels.txt - has the names and id of each activity developed in the experiment
* features.txt - includes the descriptions for features measured  
* train/X_train.txt - includes the measurements of the features in train set (one row - 1 measurement of 561 features)  
* test/X_test.txt - includes the measurements of the features in test set  
* train/subject_train.txt - subject for each measurement from the train set  
* test/subject_test.txt - subject for each measurement from the test set  
* train/y_train.txt - activity (from 1 to 6) for each measurement from the train set  
* test/y_test.txt - activity (from 1 to 6) for each measurement from the test set

# Project code
The script "run_analysis" is devided in 9 steps:  

**1) Create the directory** The first part check if exist a directory with a specific name, if not create it, then used the given link to download the zip file using download.file function and unzipping it using the unzip function.  

**2) Getting the data** First, using file.path create a path to the "UCI HAR Dataset" folder, then using the Data.table::fread function extracts all the information from the files mentioned in the Data introduction and store it in variables.  

**3) Data merge** Merge the subjects, activity and measurements variables (test and train) created in step 2 using rbind function and assigning them to a 3 new variables.  

**4) New names** Right names are assigned to the three variables created in step 3 using names function.  

**5) Full data merge** Those 3 variables are merging in one data frame using cbind function.  

**6) Important data** Only the variables related to mean and std are selected, creating a vector only with the names of the complete variables filtering them with grep function then using them to select the rigth variables of the data frame using the select function.  

**7) Matching activities ** Change the data contained in the activity variable (numbers) to the activity name using the data from activity_labels.txt with help of the merge function.  

**8) Complete names** Change the abbreviated names of the variables to the complete right names using a loop with the function names in it.  

**9) Tidy data** Calculate the mean for each variable for each activity and each subject using the aggregate function, then store it in a txt file.




