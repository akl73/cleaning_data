# Codebook for activity_summary.txt

The file has been generated from raw data available here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


The following files have been consolidated into two initial data sets:

* Test group:
 * X_test.txt - test data measurements
 * y_test.txt - test data activities (identifiers)
 * subject_test.txt - test subjects (identifiers)

* Train (experimental) group:
 * X_train.txt - train data measurements
 * y_train.txt - train data activities (identifiers)
 * subject_train.txt - train subjects (identifiers)


The values from the second column in features.txt file were applied as column names for measurements (in the order specified in features.txt).

Activity identifiers were named as activityid and Subject identifiers were named as subjectid.

Columns in activity_labels.txt have been named respectively as activityid and activity (indicating activity name).

The above datasets were then consolidated into one which was then joined with activity_labels.txt on activityid. 

The column activity was added and automatically converted into factor.

Then final detail data set was created selecting only columns with [Mm]ean or [Ss]td in the name plus activity and subjectid.
subjectid was converted into factor.

The measurement values have not been changed however the column names have been tidied following the guidelines 
from Getting and Cleaning Data Course:
* the following symbols: (,)- have been removed
* to give the column names meaningful names the following additional operations have been perfomed:
  * leading t replaced with time
  * leading f replaced with freq
  * "Acc" replaced with "acceleration"
  * "Mag" replaced with "magnitude"
* all names have been converted to lowercase


The summary data set was created from the final detail data set by grouping by activity and subjectid. The mean value was calculated
for each variable.

The data set is ordered by activity and then by subjectid.


Please refer to features_info.txt in the original data set for any additional information not covered in this Code Book regarding the data.

