Project: YELP Data Analysis 

Dataset Source:https://www.yelp.com/dataset_challenge

Sequence of Excustion: 

Step 1:
Substep 1. Excute script GetTools.R
Substep 2. Excute DATA EXTRACT.R
Substep 3. Excute DATA MODEL. R

Note: Substep 1 and Substep 2 takes more than 5 minutes to excute as it downloads data from cloud server. 

Step 2: 
Substep 1. Place 'yelp_academic_dataset_business.json' file in desired directory
Substep 2. Open the script KNNAlgorithm.R and give the path of above file on line no 16 of the script.
	For Ex: con <- file("C:/Users/abhilash/OneDrive/Documents/yelp_academic_dataset_business.json", "r")
Substep 3. Open the script Yelp_Graphical_Visulizations.R and give the path of JSON file in step 1 on line no 28


	
