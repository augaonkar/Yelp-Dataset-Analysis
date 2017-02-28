# Script 1 - Data Extraction and Re-formatting

rm(list=ls())
data_dir <- 'path goes here'
yelp_dir <- 'path goes here'
if (getwd() != paste0(data_dir,yelp_dir)) {setwd(paste0(data_dir,yelp_dir))}

install.packages("doParallel")

library(plyr)
library(dplyr)
library(stringr)
library(jsonlite)
library(doParallel)
library(foreach)

# registerDoParallel(2)


## EXTRACTING AND COMPILING YELP DATA (JSON --> RDATA)

filenames <- unzip("Yelp_Data/Yelp_challenge-dataset.zip", list = TRUE)

unzip(zipfile = "Yelp_Data/Yelp_challenge-dataset.zip",filenames[c(3:7),1],
      exdir = paste0(getwd(),"/Yelp_Data"), junkpaths =TRUE)

jsons.info <- file.info(dir("Yelp_Data", pattern ="*.json",
                             full.names =TRUE))


## Load json data to R objects
yelp_business <- fromJSON(sprintf("[%s]",
                                  paste(readLines(dir("Yelp_Data",
                                                      full.names =TRUE,
                                                      pattern ="*.json")[1]),
                                        collapse=",")))
names(yelp_business)
head(yelp_business)


yelp_review <- fromJSON(sprintf("[%s]",
                                paste(readLines(dir("Yelp_Data",
                                                    full.names =TRUE,
                                                    pattern ="*.json")[3]),
                                      collapse=",")))
names(yelp_review)
head(yelp_review)

# Erase json files
file.remove(dir("Yelp_Data", pattern = "*.json", full.names = TRUE))

# Save the raw data to image file.
save.image("Yelp_Data/Yelp-Raw.RData")

#EndScript
