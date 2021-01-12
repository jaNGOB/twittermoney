# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Code to gauge sentiment of individual tweets and create a dataframe containing daily positive or negative
# average of twitter sentiment.
#
library(sentimentr)
library(ggplot2)
library(dplyr)
library(stringr)
library(tidyquant)

# Import tickers and create a list of stocks that will be used.
all_tickers <- read.csv('Data/tickers.csv')
#all_tickers <- colnames(all_tickers[2:length(all_tickers)])
all_tickers <- all_tickers[2:length(row.names(all_tickers)),]

# Create a beginning dataframe with AMZN as it is the first ticker on the list.
tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
#tweets_AMZN$date <- as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())
sentences <- get_sentences(tweets_AMZN$tweet)
tweets_AMZN['sentiment'] <- sentiment_by(sentences)$ave_sentiment

# Remove 0 sentiment scores
tweets_AMZN <- tweets_AMZN[tweets_AMZN$sentiment != 0,]
dates <- tweets_AMZN %>% 
  group_by(date) %>% 
  summarize(sentiment = mean(sentiment), .groups = 'drop')

df <- xts(as.numeric(dates$sentiment), order.by = as.Date(dates$date))
colnames(df) <- 'AMZN'

# Loop through all tickers, clean the dataframe, create daily average twitter sentiment and save it in a daily dataframe.
loading <- 0
total <- length(all_tickers)
for (n in 1:length(all_tickers)){
  loading <- loading + 1
  print(c(loading, total))
  
  #name <- substring(all_tickers[n], 3)
  name <- all_tickers[n]
  import_file <- paste("Data/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df$date <- as.Date(temp_df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone())
  sentences <- get_sentences(temp_df$tweet)
  temp_df['sentiment'] <- sentiment_by(sentences)$ave_sentiment
  temp_df <- temp_df[temp_df$sentiment != 0,]
  temp_date <- temp_df %>% 
    group_by(date) %>% 
    summarize(sentiment = mean(sentiment), .groups = 'drop')
  
  temp_xts <- xts(as.numeric(temp_date$sentiment), order.by = as.Date(temp_date$date))
  colnames(temp_xts) <- name
  
  df <- cbind(df, temp_xts[,1])
}

df[is.na(df)] <- 0

# Save the daily sentiment scores of all stocks to a csv document for further use.
write.zoo(df,file="Data/daily_sentiment.csv", row.names=FALSE,col.names=TRUE,sep=",")

# test_df <- read.csv('Data/daily_sentiment.csv', row.names = 'Index')
