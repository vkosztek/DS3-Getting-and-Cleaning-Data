Run analysis file
=================

Note
----

I made the code one month ago for the previous class on an older version of the RStudio. when it worked fine for me.

I updated the RStudio and haven't changed anything on the code, but it is not working now and I have been unable to fix it yet(Just made it worse, that's why I commit the old code, at least that worked once. Or maybe I changed something and forgot it...) 

If you could point me out what is wrong, I would appreciate it. 

The Code
--------

There are two main function to call:

	1. getDataset()
	2. getSecondData(tidyDAta)

1. getDataset()
--------------
This function launches the other fuctions in order to produce a final dataset.

	* getZip() - first it calls an other function to check the working directory and sets it (and if "candtData" directory does not exist, creates). Then download zip from source then unzip it
	* getXData() - read xTrain and xTest data and create data frames.
	* getYData() - read yTrain and yTest data and create data frames. Then it changes the coding of activity by calling the changeActivityLabels(yData) function.
	* mergeXYData() - merge the x and y data
	* mergeSubjectData - merge subject labels to the datasets
Finally the function produces the tiny dataset by merging the test and train data.

2. getSecondData(tidyData)
--------------------------

First sort the data, then melt it and cast it.


