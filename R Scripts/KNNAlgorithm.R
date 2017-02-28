library(rjson)
library(plyr)
library(dplyr)
library(ggplot2)
library(knitr)
library(glmnet)
library(googleVis)
library(DT)
library(scales)
library(varhandle)
install.packages("caret")
library(ISLR)
library(caret)


con <- file("C:/Users/yesha/OneDrive/Documents/yelp_academic_dataset_business.json", "r")
input <- readLines(con, -1L)
close(con)
yelpdata <- input %>%
  lapply(function(x) t(unlist(fromJSON(x)))) %>% 
  ldply()
save(yelpdata, file= 'yelpdata.rdata')
load("yelpdata.rdata")

clean.names <- function(df){
  colnames(df) <- gsub("[^[:alnum:]]", "", colnames(df))
  colnames(df) <- tolower(colnames(df))
  return(df)
}
yelpdata <- clean.names(yelpdata)
yelpdata <- yelpdata[,!duplicated(colnames(yelpdata))]

all_restaurants <- filter(yelpdata, categories == "Restaurants" |
                            categories1 == "Restaurants" | 
                            categories2 == "Restaurants"| 
                            categories3 == "Restaurants"|
                            categories4 == "Restaurants"|
                            categories5 == "Restaurants"|
                            categories6 == "Restaurants"|
                            categories7 == "Restaurants"|
                            categories8 == "Restaurants"|
                            categories9 == "Restaurants"|
                            categories10 == "Restaurants") 
Restaurants_city <- filter(all_restaurants,state == "AZ")
Restaurants_city <- Restaurants_city[Restaurants_city$open==TRUE,]

View(all_restaurants) 
View(Restaurants_city) 
names(Restaurants_city)

NewData<- subset(Restaurants_city, select=c(stars,attributespricerange,attributesalcohol,attributesnoiselevel,
                                            attributesattire,attributesgoodforgroups,
                              attributesacceptscreditcards,attributesoutdoorseating,
                              attributesgoodforkids,
                              attributesdelivery,attributestakeout,
                              attributestakesreservations,attributesparkinglot
                           ))
View(NewData)
NewData<-na.omit(NewData)
NewData[,2] <- as.numeric(NewData[,2])

NewData[,1]<-unfactor(NewData[,1])
NewData$stars <- ifelse(NewData$stars < 3.0, 'LOW', 
                     ifelse(NewData$stars >= 3.0 & NewData$stars <=4,'MEDIUM','HIGH'))

table(NewData$stars)
NewData$attributestakesreservations <- ifelse(NewData$attributestakesreservations=='TRUE', 1, 
                                              ifelse(NewData$attributestakesreservations == 'FALSE' ,0,0))

NewData$attributesparkinglot <- ifelse(NewData$attributesparkinglot=='TRUE', 1, 
                                              ifelse(NewData$attributesparkinglot == 'FALSE' ,0,0))
NewData$attributesgoodforgroups <- ifelse(NewData$attributesgoodforgroups=='TRUE', 1, 
                                      ifelse(NewData$attributesgoodforgroups == 'FALSE' ,0,0))
NewData$attributesacceptscreditcards <- ifelse(NewData$attributesacceptscreditcards=='TRUE', 1, 
                                          ifelse(NewData$attributesacceptscreditcards == 'FALSE' ,0,0))
NewData$attributesoutdoorseating <- ifelse(NewData$attributesoutdoorseating=='TRUE', 1, 
                                          ifelse(NewData$attributesoutdoorseating == 'FALSE' ,0,0))
NewData$attributesgoodforkids <- ifelse(NewData$attributesgoodforkids=='TRUE', 1, 
                                         ifelse(NewData$attributesgoodforkids == 'FALSE' ,0,0))
NewData$attributesalcohol <- ifelse(NewData$attributesalcohol=='none', 1, 
                                          ifelse(NewData$attributesalcohol == 'full_bar' , 2,
                                                 ifelse(NewData$attributesalcohol == 'full_bar' ,3,0)))
NewData$attributesnoiselevel <- ifelse(NewData$attributesnoiselevel=='quiet', 1,
                                       ifelse(NewData$attributesnoiselevel=='average', 2,
                                              ifelse(NewData$attributesnoiselevel=='loud', 3,
                                          ifelse(NewData$attributesnoiselevel == 'very_loud' ,0,0))))
NewData$attributesattire <- ifelse(NewData$attributesattire=='formal', 1, 
                                   ifelse(NewData$attributesattire=='dressy', 2,
                                          ifelse(NewData$attributesattire == 'causal' ,3,0)))
NewData$attributesdelivery <- ifelse(NewData$attributesdelivery=='TRUE', 1, 
                                          ifelse(NewData$attributesdelivery == 'FALSE' ,0,0))
NewData$attributestakeout <- ifelse(NewData$attributestakeout=='TRUE', 1, 
                                          ifelse(NewData$attributestakeout == 'FALSE' ,0,0))
d1<-NewData

normalize <- function(x) {
  y <- (x - min(x))/(max(x) - min(x))
  y
}
View(d1)
View(New_Dataset)
New_Dataset <- as.data.frame(lapply(d1[2:5], normalize))
New_dataset2 <- as.data.frame(d1[6:13])
New_Dataset<-cbind( stars=d1$stars,New_Dataset,New_dataset2)
View(New_Dataset)                 
NewData<-New_Dataset
temp <- sample(nrow(NewData),as.integer(0.70 * nrow(NewData)))
Training <- NewData[temp,]
View(Training)
Test <- NewData[-temp,]
View(Test)



library(class)
table(Test[,1])
table(Training[,1])
?knn

predict<-knn(Training[,-1],Test[,-1],Training[,1],k=69 )
View(predict)


mean(predict==Training[,1])

results<-cbind(Test, as.character(predict))
View(results)
table(Actual=results[,1],Prediction=results[,14])
wrong<-results[,1]!=results[,14]
plot(results[,1],results[,14])
rate<-sum(wrong)/length(wrong)

rate

table(results[,14])
table(Test[,1])

accuracy <- rep(1, 70)
k <- 1:70
for(x in k){
  prediction <- knn(Training[,-1],Test[,-1],Training[,1],k=x )
  accuracy[x] <- mean(prediction == Training[,1])
}

plot(k, accuracy, type = 'b')
