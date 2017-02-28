#Yelp Data Analysis Project
#Abhilash Ugaonkar
# Script 0 - Acquiring Tools and Data
#This Script installs all the packages needed to excute various plots and fucntions.
#This Scripts downloads the Yelp dataset zip from cloud

rm(list=ls())

## CHECKING AND/OR INSTALLING REQUIRED TOOLS
if(!require(devtools)){install.packages('devtools')}
library("devtools")

if(!require(tm)){install.packages('tm')}
library("tm")

if(!require(jsonlite)){install.packages('jsonlite')}
library("jsonlite")

if(!require(RDataCanvas)){install_github('DataCanvasIO/RDataCanvas')}
library("RDataCanvas")

if(!require(dplyr)){install.packages('dplyr')}
library("dplyr")

if(!require(sp)){install.packages('sp')}
library(sp)

if(!require(ggmap)){install.packages('ggmap')}
library(ggmap)


## ACCESSING AND DOWNLOADING DATA
yelp_url <- "dataset URL goes here"

data_dir <- 'desktop location for yelp dir goes here...'

if (getwd() != paste0(data_dir,yelp_dir)) {setwd(paste0(data_dir,yelp_dir))}

if(!dir.exists('Yelp_Data')) {dir.create('Yelp_Data')}
download.file(yelp_url, 'Yelp_Data/Yelp_challenge-dataset.zip')


#EndScript
