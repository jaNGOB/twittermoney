# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Create a dataframe containing the amount of tweets each day for every chosen company.
# :input: Tweets of every single stock
# :output: csv with quarterly weights as well as a csv with number of tweets per day.
#
library(tidyquant)
library(dplyr)
library(data.table)
library(stringr)
library(lubridate)
library(dygraphs)

all_tickers <- read.csv('Data/tickers.csv')

# Initiallize the dataframe with one single stock (AMZN since it is the first one in the list).
tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d",tz=Sys.timezone()))
dates <- na.omit(tweets_AMZN %>% count(date))

df <- xts(as.numeric(dates$n), order.by = as.Date(dates$date))
colnames(df) <- 'AMZN'

# Overwrite all_tickers to a new list, containing all tickers without AMZN.
all_tickers <- all_tickers[2:length(row.names(all_tickers)),]

# Main loop which goes through all stocks chosen and adds a new column to "df" containing the number of tweets per day.
loading <- 0
total <- length(all_tickers)
for (n in 1:total){
  loading <- loading + 1
  print(c(loading, total))
  name <- all_tickers[n]
  cname <- paste('$', name, sep='')
  import_file <- paste("Data/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df$date <- (as.Date(temp_df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
  temp_date <- na.omit(temp_df %>% count(date))
  
  temp_xts <- xts(as.numeric(temp_date$n), order.by = as.Date(temp_date$date))
  colnames(temp_xts) <- name
  
  df <- cbind(df, temp_xts[,1])
}

# if there are NaN values in the dataframe, replace them by zero.
df[is.na(df)] <- 0

# create quarterly aggregation of tweets and calculate the weight compared to all tweets.
QuarterlyWeight<- function(df) {
  # Function to create a xts frame containing the time-series of a weighted 
  #
  # :input w: quarterly weights
  # :output: xts 
  fquarter <- xts(t(getWeights(df['2020-01-01'])), order.by = as.Date('2020-01-01'))
  squarter <- xts(t(getWeights(df['2020-01-02/2020-03'])), order.by = as.Date('2020-04-02'))
  tquarter <- xts(t(getWeights(df['2020-04/2020-06'])), order.by = as.Date('2020-07-01'))
  lquarter <- xts(t(getWeights(df['2020-07/2020-09'])), order.by = as.Date('2020-10-01'))
  
  Index <- rbind.xts(fquarter,squarter,tquarter,lquarter)
  
  return(Index)
}

getWeights <- function(df){
  # Function to get the weights of each element of a given dataframe.
  #
  # :input df: "count" dataframe
  # :output: dataframe containing one row which signify the weight each asset (Colname) should get.
  sum_all <- sum(df)
  sum_row <- sapply(df, sum)
  return(sum_row/sum_all)
}

weights <- QuarterlyWeight(df)

# Save the two dataframes as a csv for future use.
# write.zoo(df,file="Data/daily_count.csv", row.names=FALSE,col.names=TRUE,sep=",")
# write.zoo(weights,file="Data/quarterly_weights.csv", row.names=FALSE,col.names=TRUE,sep=",")

# read.csv('Data/quarterly_weights.csv', row.names = 'Index')

# Aggregate the number of tweets per weekday to see some cyclicality. From a line plot one can already spot, 
# that there are less tweets on the weekend. This Barplot proves this first look.
wd <- data.frame(wday(as.Date(index(df))), row.names = as.Date(index(df)))
colnames(wd) <- 'weekday'

wddf <- data.frame(df)
wddf$weekday <- wd

mon <- sum(sapply(subset(wddf, wddf$weekday == 2)[,-length(colnames(wddf))], sum))
tue <- sum(sapply(subset(wddf, wddf$weekday == 3)[,-length(colnames(wddf))], sum))
wed <- sum(sapply(subset(wddf, wddf$weekday == 4)[,-length(colnames(wddf))], sum))
thu <- sum(sapply(subset(wddf, wddf$weekday == 5)[,-length(colnames(wddf))], sum))
fri <- sum(sapply(subset(wddf, wddf$weekday == 6)[,-length(colnames(wddf))], sum))
sat <- sum(sapply(subset(wddf, wddf$weekday == 7)[,-length(colnames(wddf))], sum))
sun <- sum(sapply(subset(wddf, wddf$weekday == 1)[,-length(colnames(wddf))], sum))

weekdays <- cbind(mon, tue, wed, thu, fri, sat, sun)

barplot(weekdays,
        xlab = 'Weekday',
        ylab = 'Number of mentions',
        beside=TRUE, 
        ylim=range(pretty(c(0, weekdays))))
