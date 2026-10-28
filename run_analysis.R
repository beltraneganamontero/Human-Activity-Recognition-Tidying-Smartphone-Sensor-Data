# Getting and Cleaning Data - Course Project
# Human Activity Recognition Using Smartphones (UCI HAR)
# Run from the directory containing this file: source("run_analysis.R")
# Requires only base R; no extra packages are needed.

# 0. Locate the original data. If necessary, download and extract them.
data_dir <- "UCI HAR Dataset"
data_url <- paste0(
  "https://d396qusza40orc.cloudfront.net/getdata%2F",
  "projectfiles%2FUCI%20HAR%20Dataset.zip"
)
zip_file <- "UCI_HAR_Dataset.zip"

if (!dir.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    message("Downloading the original UCI HAR data ...")
    tryCatch(
      download.file(data_url, destfile = zip_file, mode = "wb"),
      error = function(e) stop(
        "Automatic download failed. Download and extract the data ",
        "manually as explained in README.md. Details: ", conditionMessage(e)
      )
    )
  }
  message("Extracting the UCI HAR data ...")
  unzip(zip_file)
}

needed <- c(
  "features.txt", "activity_labels.txt",
  "train/X_train.txt", "train/y_train.txt", "train/subject_train.txt",
  "test/X_test.txt", "test/y_test.txt", "test/subject_test.txt"
)
missing_files <- needed[!file.exists(file.path(data_dir, needed))]
if (length(missing_files) > 0L) {
  stop("The dataset is incomplete. Missing: ",
       paste(missing_files, collapse = ", "))
}

# 1. Read feature descriptions and select exact mean() and std() variables.
features <- read.table(
  file.path(data_dir, "features.txt"),
  header = FALSE, stringsAsFactors = FALSE,
  col.names = c("FeatureIndex", "FeatureName")
)
activity_labels <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  header = FALSE, stringsAsFactors = FALSE,
  col.names = c("ActivityID", "Activity")
)

# Select only the original features calculated as mean() or std().
# This deliberately excludes meanFreq() and angle(...mean...) features.
selected <- grep("-(mean|std)\\(\\)", features$FeatureName)
stopifnot(nrow(features) == 561L, length(selected) == 66L)

# Each observation consists of a subject ID, activity code, and 561 measures.
# We read all feature columns, then retain the selected 66 columns.
read_part <- function(part) {
  x <- read.table(
    file.path(data_dir, part, paste0("X_", part, ".txt")),
    header = FALSE
  )
  activity_id <- scan(
    file.path(data_dir, part, paste0("y_", part, ".txt")),
    what = integer(), quiet = TRUE
  )
  subject_id <- scan(
    file.path(data_dir, part, paste0("subject_", part, ".txt")),
    what = integer(), quiet = TRUE
  )
  stopifnot(ncol(x) == 561L,
            nrow(x) == length(activity_id),
            nrow(x) == length(subject_id))

  data.frame(
    Subject = subject_id,
    ActivityID = activity_id,
    x[, selected, drop = FALSE],
    check.names = FALSE
  )
}

# Requirement 1: combine training and test observations.
training <- read_part("train")
testing <- read_part("test")
combined <- rbind(training, testing)
stopifnot(nrow(combined) == 10299L)

# Requirement 3: use descriptive activity names, preserving the official labels.
activity <- activity_labels$Activity[
  match(combined$ActivityID, activity_labels$ActivityID)
]
stopifnot(!anyNA(activity))

# Requirement 4: give the 66 selected measurement columns descriptive names.
# The extra 'Body' in some original frequency-domain labels is redundant.
clean_feature_names <- function(x) {
  x <- sub("^t", "Time", x)
  x <- sub("^f", "Frequency", x)
  x <- gsub("BodyBody", "Body", x, fixed = TRUE)
  x <- gsub("Acc", "Accelerometer", x, fixed = TRUE)
  x <- gsub("Gyro", "Gyroscope", x, fixed = TRUE)
  x <- gsub("Mag", "Magnitude", x, fixed = TRUE)
  x <- gsub("-mean\\(\\)", "Mean", x)
  x <- gsub("-std\\(\\)", "Std", x)
  gsub("[^A-Za-z0-9]", "", x)
}

measurement_names <- clean_feature_names(features$FeatureName[selected])
stopifnot(length(unique(measurement_names)) == 66L)

# Requirements 2-4: the first clean dataset, one row per original window.
measurements <- combined[, -(1:2), drop = FALSE]
names(measurements) <- measurement_names
clean_data <- data.frame(
  Subject = combined$Subject,
  Activity = activity,
  measurements,
  check.names = FALSE
)
stopifnot(nrow(clean_data) == 10299L, ncol(clean_data) == 68L)

# Requirement 5: a second, independent tidy dataset.
# Each row is one Subject x Activity combination and each measurement
# is the arithmetic mean across all its observation windows.
tidy_data <- aggregate(
  clean_data[measurement_names],
  by = clean_data[c("Subject", "Activity")],
  FUN = mean
)
tidy_data <- tidy_data[
  order(tidy_data$Subject, tidy_data$Activity), , drop = FALSE
]
rownames(tidy_data) <- NULL

# Sanity checks: 30 subjects, 6 activities, 66 averaged variables.
stopifnot(nrow(tidy_data) == 180L,
          ncol(tidy_data) == 68L,
          length(unique(tidy_data$Subject)) == 30L,
          length(unique(tidy_data$Activity)) == 6L,
          !anyDuplicated(tidy_data[c("Subject", "Activity")]),
          !anyNA(tidy_data))

# Produce the tab-separated file requested by Coursera. No row numbers.
write.table(
  tidy_data, file = "tidy_data.txt", sep = "\t",
  row.names = FALSE, quote = FALSE
)

message("Success: tidy_data.txt created in ", getwd())
message("Observations: ", nrow(tidy_data),
        "; variables: ", ncol(tidy_data))
# Optional: inspect the output from RStudio with View(tidy_data).
