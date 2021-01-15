# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# December 2020
# 
# Create indicators to capture, represent and potentially identify anomalies in Twitter data.
#
library(dplyr)
library(sentimentr)
library(tidyquant)
library(PerformanceAnalytics)
library(ggplot2)
library(quantmod)


# Import relevant data for further use.
all_tickers <- read.csv('Data/tickers.csv')
sent <- read.csv('Data/daily_sentiment.csv', row.names = 'Index')
count <- read.csv('Data/daily_count.csv', row.names = 'Index')
price <- read.csv("Data/stock_prices.csv", row.names = "Index")
price <- xts(price, order.by = as.Date(row.names(price)))


counter <- function(df, name){
  # Function which counts the amount of occurences per day.
  #
  # :input df: dataframe with a "date" column which will be used for counting.
  # :input name: the colname of the output xts.
  # :output temp: xts containing the number of occurences per day.
  temp <- na.omit(df %>% count(date))  
  temp <- xts(as.numeric(temp$n), order.by = as.Date(temp$date))
  colnames(temp) <- name
  return(temp)
}

#
# BUllshit based on pointless tweets!
# This is a conceptual test to capture the value of tweets. If the sentiment score is 0, 
# the tweet will be seen as useless. As long as it has any score, it contains potentially valuable
# information and is therefore added as a valuable tweet.
# 
# DISCLAIMER: This is only implemented for a single stock (AMZN).
#

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
tweets_AMZN$date <- as.Date(tweets_AMZN$date,format="%Y-%m-%d",tz=Sys.timezone())
tweets_AMZN$tweet <- sapply(tweets_AMZN$tweet, toString)
sentences <- get_sentences(tweets_AMZN$tweet)
tweets_AMZN['sentiment'] <- sentiment_by(sentences)$ave_sentiment

valuable <- tweets_AMZN[tweets_AMZN$sentiment != 0,]
bs <- tweets_AMZN[tweets_AMZN$sentiment == 0,]

dates_val <- counter(valuable, 'valuable')
dates_bs <- counter(bs, 'bs')

indi <- dates_val / dates

par(mfrow=c(2,1))
plot(AMZN$AMZN.Adjusted)
plot(indi)

#
# Bullshit based on pointless people!
# This implementation compares the number of tweets of people who are verified to the total number 
# of tweets in the same day. The goal of this indicator is to see, if the market moves as the number of
# verified and potentially influencial twitter users use the cashtag more than ususal.
# This is implemented for the overall stockmarket and compared to the S&P500.
#

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE)
verified <- counter(tweets_AMZN[tweets_AMZN$verified != 0,], 'AMZN')

# veri_bs <- tweets_AMZN[tweets_AMZN$verified == 0,]

df <- xts(as.numeric(verified), order.by = as.Date(index(verified)))
colnames(df) <- 'AMZN'

# Overwrite all_tickers to a new list, containing all tickers without AMZN.
all_tickers <- all_tickers[2:length(row.names(all_tickers)),]


# Loop through all tickers and add the number of tweets from verified users per day to a xts.
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
  verified <- counter(temp_df[temp_df$verified != 0,], name)
  
  df <- merge(df, verified)
}
df[is.na(df)] <- 0

# Sum up the verified tweets per day and the total amount of tweets per day.
combined_verified <- rowSums(df)
combined_count <- rowSums(count)

indi <- xts(combined_verified / combined_count, order.by = as.Date(index(df)))

getSymbols("^GSPC", from ="2019-12-31", to = "2020-11-30", src = "yahoo", auto.assign = T)

par(mfrow=c(2,1))
plot(GSPC$GSPC.Adjusted, main = 'S&P 500')
plot(indi, type= 'l', main = 'Bullsh*t Indicator')

#
# Bullshit based on pointless tweets, again? Again!
# This implementation compares tweets that have any amount of favorites to tweets which have none.
# The idea behind this is, that if more tweets are getting recognized/favourized, the market might move.
#
# DISCLAIMER: This is only implemented for a single stock (AMZN).
#

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
liked <- tweets_AMZN[tweets_AMZN$amount_favorite != 0,]
sadge <- tweets_AMZN[tweets_AMZN$amount_favorite == 0,]

dates_liked <- counter(liked, 'liked')
dates_sadge <- counter(sadge, 'sadge')

indi <- dates_sadge / dates
indi_z <- scale(indi)

par(mfrow=c(2,1))
plot(AMZN$AMZN.Adjusted)
plot(indi)

#
# Bullshit based on leaders and losers 
# Finally, this indicator uses a ratio of followers to following to determine if they are important. 
# The hypothesis behind it is, that users who have a high ratio (a lot of followers compared to a small
# amount of people their following) tweet information that will be seen by a lot of people.
# The threshold, when a user is identified as a leader can be changed by changing the "thres" variable.
#
# DISCLAIMER: This is only implemented for a single stock (AMZN).
#

thres <- 100

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE)
leader <- tweets_AMZN[tweets_AMZN$followers / tweets_AMZN$following > thres,]
losers <- tweets_AMZN[tweets_AMZN$followers / tweets_AMZN$following <= thres,]

dates_leader <- counter(leader, 'leaders')
dates_loser<- counter(losers, 'losers')

indi <- dates_leader / dates
indi_z <- scale(indi)

par(mfrow=c(2,1))
plot(AMZN$AMZN.Adjusted)
plot(indi)
