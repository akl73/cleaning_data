# cleaning_data
## Getting and Cleaning Data Course Project

The repo contains the following files:
* run_analysis.R - script which creates tidy data set
* activity_data.csv - clean data set
* activity_summary.csv - summary data set of activity_data.csv
* CodeBook.md - a code book describing the operations performed on the raw data to generate activity_data.csv and activity_summary.csv

run_analysis.R can be run in R or RStudio.

run_analysis.R requires following packages:
* data.table
* plyr
* dplyr
They need to be installed prior to running the script.
The script will load them in the first step.

The raw data will be downloaded from the following location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
to the ./data folder (it will be created if does not exist).

Then the relevant files required to produce the tidy data set will be extracted from the downloaded zip.

The next steps are to consolidate test and train data, add column names, add activity values,
subset only variables relevant to this project and rearrange columns so factors (activity and subjectid)
as at the front.
Also column names as tidied following Getting and Cleaning Data Course guidelines.

In the next step the summary data set is produced from the tidy data set - means of all variables
grouped by activity and subjectid.

In the last step both data sets are saved to the csv files.

More information on transforms performed can be found in CodeBook.md and also there are comments in run_analysis.R.



