# CodeBook — UCI HAR Sensor Measurement Averages

## Overview

This code book describes `tidy_data.txt`, produced by `run_analysis.R` for the Johns Hopkins University **Getting and Cleaning Data** course project. The source is the **Human Activity Recognition Using Smartphones Dataset (Version 1.0)** from the UCI Machine Learning Repository, distributed via Coursera.

- Dataset: [Human Activity Recognition Using Smartphones](https://archive.ics.uci.edu/dataset/240/human+activity+recognition+using+smartphones)
- Coursera source archive: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>
- Original documentation: `UCI HAR Dataset/README.txt` and `UCI HAR Dataset/features_info.txt`.

## Subjects, activities and observations

The original study includes 30 volunteers, identified by integers 1 through 30, who performed six physical activities while wearing a Samsung Galaxy S II at the waist. Each original observation corresponds to one time-window feature vector; the original data are separated into training and test partitions.

The final tidy dataset is a **wide table with 180 rows and 68 columns**:

- **One row:** one unique (`Subject`, `Activity`) pair (30 subjects × 6 activities).
- **One column per variable:** subject identifier, descriptive activity label, and the arithmetic average of each of 66 mean/standard-deviation measurements.
- **One value per cell:** a single subject, activity, or averaged measurement value.

### Identifier and categorical variables

| Variable | Type | Definition | Unit |
| --- | --- | --- | --- |
| `Subject` | Integer | Identifier of the participating volunteer; 1 through 30 | None (identifier) |
| `Activity` | Character | Human-readable movement class | None (categorical) |

The possible `Activity` values, taken directly from `activity_labels.txt`, are:

| Original activity ID | Output activity label |
| --- | --- |
| 1 | `WALKING` |
| 2 | `WALKING_UPSTAIRS` |
| 3 | `WALKING_DOWNSTAIRS` |
| 4 | `SITTING` |
| 5 | `STANDING` |
| 6 | `LAYING` |

### Measurement variables and units

The 66 columns correspond exclusively to measurements whose original feature names contain `-mean()` or `-std()`. Features containing `meanFreq()` or the word `mean` inside other expressions (e.g., `angle(...)`) were intentionally excluded, to use a precise, reproducible selection criterion.

The sensor features were **already normalized and bounded approximately between −1 and 1** in the source feature dataset (`features_info.txt`). Thus the final variables are **dimensionless normalized feature averages**, rather than raw acceleration values in g or angular velocity in radians/second. Every value in a measurement column is the arithmetic average over source windows for the specified subject and activity.

#### Naming convention

| Code in original name | Meaning in output name |
| --- | --- |
| Initial `t` | `Time`: time-domain feature |
| Initial `f` | `Frequency`: frequency-domain feature (Fast Fourier Transform) |
| `Body` | Motion associated with the body |
| `Gravity` | Gravity-related component |
| `Acc` | `Accelerometer`: linear acceleration data |
| `Gyro` | `Gyroscope`: angular velocity data |
| `Jerk` | Time derivative of the original motion signal |
| `Mag` | `Magnitude`: signal magnitude |
| `mean()` | `Mean`: original window's mean feature |
| `std()` | `Std`: original window's standard-deviation feature |
| `X`, `Y`, `Z` | Component axis |

An original `BodyBody` prefix in some frequency-domain magnitude variables is simplified to `Body` for legibility; it is not a new signal or calculation. Parentheses, hyphens and punctuation are removed. `Mean`/`Std` in the final column name refer to **which original feature was selected**; every such column is *then averaged again* across all the windows for that subject and activity.

### Complete dictionary of the 66 measurement columns

All entries have type **numeric**, unit **normalized, dimensionless**, and contain the **arithmetic mean across windows** for the given subject and activity. The original names are shown to make each column auditable against `features.txt`.

| Original feature in `features.txt` | Column in `tidy_data.txt` |
| --- | --- |
| `tBodyAcc-mean()-X` | `TimeBodyAccelerometerMeanX` |
| `tBodyAcc-mean()-Y` | `TimeBodyAccelerometerMeanY` |
| `tBodyAcc-mean()-Z` | `TimeBodyAccelerometerMeanZ` |
| `tBodyAcc-std()-X` | `TimeBodyAccelerometerStdX` |
| `tBodyAcc-std()-Y` | `TimeBodyAccelerometerStdY` |
| `tBodyAcc-std()-Z` | `TimeBodyAccelerometerStdZ` |
| `tGravityAcc-mean()-X` | `TimeGravityAccelerometerMeanX` |
| `tGravityAcc-mean()-Y` | `TimeGravityAccelerometerMeanY` |
| `tGravityAcc-mean()-Z` | `TimeGravityAccelerometerMeanZ` |
| `tGravityAcc-std()-X` | `TimeGravityAccelerometerStdX` |
| `tGravityAcc-std()-Y` | `TimeGravityAccelerometerStdY` |
| `tGravityAcc-std()-Z` | `TimeGravityAccelerometerStdZ` |
| `tBodyAccJerk-mean()-X` | `TimeBodyAccelerometerJerkMeanX` |
| `tBodyAccJerk-mean()-Y` | `TimeBodyAccelerometerJerkMeanY` |
| `tBodyAccJerk-mean()-Z` | `TimeBodyAccelerometerJerkMeanZ` |
| `tBodyAccJerk-std()-X` | `TimeBodyAccelerometerJerkStdX` |
| `tBodyAccJerk-std()-Y` | `TimeBodyAccelerometerJerkStdY` |
| `tBodyAccJerk-std()-Z` | `TimeBodyAccelerometerJerkStdZ` |
| `tBodyGyro-mean()-X` | `TimeBodyGyroscopeMeanX` |
| `tBodyGyro-mean()-Y` | `TimeBodyGyroscopeMeanY` |
| `tBodyGyro-mean()-Z` | `TimeBodyGyroscopeMeanZ` |
| `tBodyGyro-std()-X` | `TimeBodyGyroscopeStdX` |
| `tBodyGyro-std()-Y` | `TimeBodyGyroscopeStdY` |
| `tBodyGyro-std()-Z` | `TimeBodyGyroscopeStdZ` |
| `tBodyGyroJerk-mean()-X` | `TimeBodyGyroscopeJerkMeanX` |
| `tBodyGyroJerk-mean()-Y` | `TimeBodyGyroscopeJerkMeanY` |
| `tBodyGyroJerk-mean()-Z` | `TimeBodyGyroscopeJerkMeanZ` |
| `tBodyGyroJerk-std()-X` | `TimeBodyGyroscopeJerkStdX` |
| `tBodyGyroJerk-std()-Y` | `TimeBodyGyroscopeJerkStdY` |
| `tBodyGyroJerk-std()-Z` | `TimeBodyGyroscopeJerkStdZ` |
| `tBodyAccMag-mean()` | `TimeBodyAccelerometerMagnitudeMean` |
| `tBodyAccMag-std()` | `TimeBodyAccelerometerMagnitudeStd` |
| `tGravityAccMag-mean()` | `TimeGravityAccelerometerMagnitudeMean` |
| `tGravityAccMag-std()` | `TimeGravityAccelerometerMagnitudeStd` |
| `tBodyAccJerkMag-mean()` | `TimeBodyAccelerometerJerkMagnitudeMean` |
| `tBodyAccJerkMag-std()` | `TimeBodyAccelerometerJerkMagnitudeStd` |
| `tBodyGyroMag-mean()` | `TimeBodyGyroscopeMagnitudeMean` |
| `tBodyGyroMag-std()` | `TimeBodyGyroscopeMagnitudeStd` |
| `tBodyGyroJerkMag-mean()` | `TimeBodyGyroscopeJerkMagnitudeMean` |
| `tBodyGyroJerkMag-std()` | `TimeBodyGyroscopeJerkMagnitudeStd` |
| `fBodyAcc-mean()-X` | `FrequencyBodyAccelerometerMeanX` |
| `fBodyAcc-mean()-Y` | `FrequencyBodyAccelerometerMeanY` |
| `fBodyAcc-mean()-Z` | `FrequencyBodyAccelerometerMeanZ` |
| `fBodyAcc-std()-X` | `FrequencyBodyAccelerometerStdX` |
| `fBodyAcc-std()-Y` | `FrequencyBodyAccelerometerStdY` |
| `fBodyAcc-std()-Z` | `FrequencyBodyAccelerometerStdZ` |
| `fBodyAccJerk-mean()-X` | `FrequencyBodyAccelerometerJerkMeanX` |
| `fBodyAccJerk-mean()-Y` | `FrequencyBodyAccelerometerJerkMeanY` |
| `fBodyAccJerk-mean()-Z` | `FrequencyBodyAccelerometerJerkMeanZ` |
| `fBodyAccJerk-std()-X` | `FrequencyBodyAccelerometerJerkStdX` |
| `fBodyAccJerk-std()-Y` | `FrequencyBodyAccelerometerJerkStdY` |
| `fBodyAccJerk-std()-Z` | `FrequencyBodyAccelerometerJerkStdZ` |
| `fBodyGyro-mean()-X` | `FrequencyBodyGyroscopeMeanX` |
| `fBodyGyro-mean()-Y` | `FrequencyBodyGyroscopeMeanY` |
| `fBodyGyro-mean()-Z` | `FrequencyBodyGyroscopeMeanZ` |
| `fBodyGyro-std()-X` | `FrequencyBodyGyroscopeStdX` |
| `fBodyGyro-std()-Y` | `FrequencyBodyGyroscopeStdY` |
| `fBodyGyro-std()-Z` | `FrequencyBodyGyroscopeStdZ` |
| `fBodyAccMag-mean()` | `FrequencyBodyAccelerometerMagnitudeMean` |
| `fBodyAccMag-std()` | `FrequencyBodyAccelerometerMagnitudeStd` |
| `fBodyBodyAccJerkMag-mean()` | `FrequencyBodyAccelerometerJerkMagnitudeMean` |
| `fBodyBodyAccJerkMag-std()` | `FrequencyBodyAccelerometerJerkMagnitudeStd` |
| `fBodyBodyGyroMag-mean()` | `FrequencyBodyGyroscopeMagnitudeMean` |
| `fBodyBodyGyroMag-std()` | `FrequencyBodyGyroscopeMagnitudeStd` |
| `fBodyBodyGyroJerkMag-mean()` | `FrequencyBodyGyroscopeJerkMagnitudeMean` |
| `fBodyBodyGyroJerkMag-std()` | `FrequencyBodyGyroscopeJerkMagnitudeStd` |

## Cleaning and transformation procedure

1. **Import metadata:** read `features.txt` and `activity_labels.txt`.
2. **Select measurements:** identify exactly 66 mean/standard-deviation features with the regular expression `-(mean|std)\(\)`.
3. **Load training and testing:** read `X_train.txt`, `y_train.txt`, `subject_train.txt` and the corresponding testing files, ensuring subject IDs and activities remain aligned with each original feature row.
4. **Combine datasets:** append the 7,352 training windows and 2,947 testing windows, producing **10,299 rows**.
5. **Apply activity labels:** look up the six descriptive categories in `activity_labels.txt` using the activity code as the key.
6. **Rename variables:** transform feature names using the mapping above, retaining unique, interpretable columns.
7. **Aggregate:** group by `Subject` and `Activity`, compute the arithmetic mean of each of 66 selected features within that group, and sort by subject then activity.
8. **Export:** save a tab-separated text file (`tidy_data.txt`) with the header row, without quotes or row indices (`write.table(..., row.names = FALSE, quote = FALSE, sep = "\t")`).

The script checks that the intermediate data contain **10,299 rows and 68 columns**, and the final dataset contains **180 rows and 68 columns**, with no repeated subject/activity combinations and no missing values.

## Source attribution

Original dataset: Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto, and collaborators, *Human Activity Recognition Using Smartphones Dataset*, Version 1.0 (2012). See the source `README.txt` for original collection and methodology. Published study: Anguita et al., *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*, IWAAL 2012.
