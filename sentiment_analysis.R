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

# Import tickers and create a list of stocks that will be used.
all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')
all_tickers <- colnames(all_tickers[2:length(all_tickers)])

# Create a beginning dataframe with AMZN as it is the first ticker on the list.
tweets_AMZN <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/AMZN_tweets_full.csv', header = TRUE) 
tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
tweets_AMZN <- tweets_AMZN %>% mutate(tag = ifelse(str_detect(tweets_AMZN$tweet, fixed('$AMZN',  ignore_case=TRUE)), TRUE, FALSE))
tweets_AMZN <- tweets_AMZN[tweets_AMZN$tag == TRUE,]
tweets_AMZN['sentiment'] <- NA
for (i in 1:length(tweets_AMZN)){
  tweets_AMZN$sentiment[i] <- sentiment_by(tweets_AMZN$tweet[i])$ave_sentiment
}


# Loop through all tickers, clean the dataframe, create daily average twitter sentiment and save it in a daily dataframe.
for (n in 1:length(all_tickers)){
  name <- substring(all_tickers[n], 3)
  print(name)
  cname <- paste('$', name, sep='')
  import_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df <- temp_df %>% mutate(tag = ifelse(str_detect(temp_df$tweet, fixed(cname,  ignore_case=TRUE)), TRUE, FALSE))
  temp_df <- temp_df[temp_df$tag == TRUE,]
  temp_df$date <- (as.Date(temp_df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
  temp_df['sentiment'] <- NA

  for (i in 1:length(temp_df)){
    temp_df$sentiment[i] <- sentiment_by(tweets_AMZN$tweet[i])$ave_sentiment
  }
  
}

qplot(tweets_AMZN$sentiment[tweets_AMZN$sentiment != 0], geom="histogram",binwidth=0.05,main="Amazon Twitter Sentiment Histogram")

