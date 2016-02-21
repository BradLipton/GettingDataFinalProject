==================================================================
Human Activity Recognition Using Smartphones Dataset --
Averages of STD and Mean Variables for
Each Subject/Activity/Measurement 
==================================================================

This dataset is a transformation of Version 1.0 of the
Human Activity Recognition Using Smartphones Dataset.

From the original dataset description: 
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist."

The transformed dataset contains averages of the standard deviation and mean variables 
for each subject/activity/measurement of the original dataset, according to the variable
description that follows.

Here are the variables in the transformed dataset and their descriptions:

Row 1: subject: The subject (numbered according to original dataset)

Row 2: activity: The activity (as provided in original dataset)

Row 3: measurement: The measurement in question, in a readable format. Note that the original
      dataset included many more measurements, as this dataset has been
      filtered down to just include the MEAN and STD measurements. Note
      also that the measurement labels have been transformed for readability.

Row 4: mean: The mean of the subject/activity/measurement in question. Obviously, a transformation
      of the original data has been performed:  the mean has been taken.
      The unit for the acceleration measurements is standard gravity units 'g', and the unit
      for the gyroscope measurements are radians/second.