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
library(dygraphs)

all_tickers <- read.csv('Data/tickers.csv')

# Initiallize the dataframe with one single stock (AMZN since it is the first one in the list).
tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
dates <- na.omit(tweets_AMZN %>% count(date))

df <- xts(as.numeric(dates$n), order.by = as.Date(dates$date))
colnames(df) <- 'AMZN'

# Overwrite all_tickers to a new list, containing all tickers without AMZN.
all_tickers <- colnames(all_tickers[2:length(all_tickers)])

# Main loop which goes through all stocks chosen and adds a new column to "df" containing the number of tweets per day.
loading <- 0
total <- length(all_tickers)
for (n in 1:total){
  loading <- loading + 1
  print(c(loading, total))
  name <- substring(all_tickers[n], 3)
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
quarterly <- aggregate(df, as.yearqtr, mean)
sum_ <- rowSums(quarterly)
weights <- xts(round(quarterly/rowSums(quarterly), 4))

p <- dygraph(weights)

# Save the two dataframes as a csv for future use.
write.zoo(df,file="Data/daily_count.csv", row.names=FALSE,col.names=TRUE,sep=",")
write.zoo(weights,file="Data/quarterly_weights.csv", row.names=FALSE,col.names=TRUE,sep=",")

read.csv('Data/quarterly_weights.csv', row.names = 'Index')
