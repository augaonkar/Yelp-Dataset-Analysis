#Yelp Data Analysis Project
#Abhilash Ugaonkar
# This R script does the h-clustering and recommendation model 
# Script 3 - Preliminary Data Modeling

rm(list=ls())
load("Yelp_Data/Yelp-Raw.RData")
set.seed(2423)

install.packages("topicmodels")
install.packages("RTextTools")
install.packages("wordcloud")
install.packages("SnowballC")
library(tm)
library(dplyr)
library(ggmap)
library(ggplot2)
library(stringr)
library(jsonlite)
library(RColorBrewer)
library(topicmodels)
library(RTextTools)
library(wordcloud)
library(SnowballC)
rm(filenames,jsons.info,data_dir,yelp_dir) # NOT NECESSARY ANYMORE

# QUICK LOOK AT DATA STRUCTURES
str(yelp_business, max.level =1)
str(yelp_review, max.level =1)


# CLEANING AND MAPPING WITH THE "BUSINESS" DATASET
business.reduced <- yelp_business[,1:13]
View(business.reduced)

business.reduced <- business.reduced[business.reduced$open==TRUE,]
View(business.reduced)

business.reduced <- business.reduced[,-3:-4]
View(business.reduced)

business.reduced <- business.reduced[,-7]
View(business.reduced)

states.keep <- vector("list", length=length(table(business.reduced$state)))
#View(states.keep)

for (i in 1:length(table(business.reduced$state))) {
  states.keep[i] <- (table(business.reduced$state)[i] >= 200)
}
states <- names(table(business.reduced$state)[unlist(states.keep)])
View(states)
business.keep <- subset(business.reduced, is.element(business.reduced$state,
                                                     intersect(states,unique(business.reduced$state))))
View(business.reduced)

rm(business.reduced, i, states.keep, states)

View(business.reduced)

#Businesses Recommnedation Code 
#Given a rating and city below code shows the available restaurents on Google Map.

choose.place <- function(good=4,state=sample(unique(business.keep$state),1)) {
  business.chosen <- business.keep[(business.keep$stars >= good),]
  business.pick <<- business.chosen[(business.chosen$state==state),]
}
choose.place()
View(business.pick)


cities.keep <- vector("list", length=length(table(business.pick$city)))
for (i in 1:length(table(business.pick$city))) {
  cities.keep[i] <- (table(business.pick$city)[i] >= 50)
}

View(cities.keep)

cities <- names(table(business.pick$city)[unlist(cities.keep)])
View(cities)
business.plt <- subset(business.pick, is.element(business.pick$city,
                                                 intersect(cities,unique(business.pick$city))))

View(business.plt)
rm(i, cities, cities.keep, business.keep, business.pick, choose.place)


# mapping first 50 businesses from a randomly chosen city in the state specified
city.plt <- subset(business.plt,
                   business.plt$city==unique(business.plt$city)[sample(length(unique(business.plt$city)),1)])
View(city.plt)
df <- round(data.frame(longitude = city.plt$longitude,
                       latitude = city.plt$latitude), 2)
View(df)

map <- get_googlemap(as.character(unique(city.plt$city)),
                     markers = df[1:50,], path = df[1:50,], scale = 2, zoom=12)
ggmap(map) + ggtitle(paste(unique(city.plt$city),
                           unique(city.plt$state),sep=', '))


# review count versus business star
qplot(city.plt$review_count,city.plt$stars,xlab="Review Counts",ylab="Stars",
      main=paste(unique(city.plt$city),unique(city.plt$state),sep=', '))
cor.test(city.plt$review_count, city.plt$stars)
rm(yelp_business, business.plt, df, map)


# EXAMINING THE "REVIEW" DATASET

str(yelp_review$votes)
sum(yelp_review$votes)
round(table(yelp_review$stars)/sum(table(yelp_review$stars)),3)
review.cleaned <- yelp_review[,-1:-3]
review.cleaned <- review.cleaned[,-4:-5]
View(review.cleaned)

# examining text data from reviews
reviews <- Corpus(VectorSource(review.cleaned[1:1000,3]))


toSpace <- content_transformer(function(x,pattern) {gsub(pattern, " ", x)})
docs <- tm_map(reviews, toSpace, "/")
docs <- tm_map(reviews, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, stemDocument)
dtm <- DocumentTermMatrix(docs)
rm(reviews, yelp_review)

# dtm <- removeSparseTerms(dtm, 0.80)
tt <- findFreqTerms(dtm, lowfreq = 200)
View(table(tt))
termFreq <- colSums(as.matrix(dtm[,tt]))
View(table(termFreq))
qplot(names(termFreq), termFreq, geom="bar", stat="identity") + coord_flip()

m <- as.matrix(t(dtm))
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

# generate barplot of word frequencies
barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="steelblue", main ="Words Most Frequently Used",
        ylab ="Frequency Counts")

# generate the word cloud
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35,
          colors=brewer.pal(8, "Dark2"))

# hierarchical clustering and heatmap of common words
tdmat <- (removeSparseTerms(t(dtm[,tt]), sparse=0.75))
distMatrix <- dist(scale(tdmat)) # compute distances
fit <- hclust(distMatrix, method="ward.D2")
plot(fit)
heatmap(as.matrix(distMatrix))

#EndScript
