library(tidyquant)
library(dplyr)
library(data.table)
library(stringr)
library(dygraphs)

all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')

tweets_AMZN <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/AMZN_tweets_full.csv', header = TRUE) 

tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))

# Clean Tweets from unwanted mentions. 
tweets_AMZN <- tweets_AMZN %>% mutate(tag = ifelse(str_detect(tweets_AMZN$tweet, fixed("$AMZN",  ignore_case=TRUE)), TRUE, FALSE))

dates <- na.omit(tweets_AMZN %>% count(date))

df <- xts(as.numeric(dates$n), order.by = as.Date(dates$date))
colnames(df) <- 'AMZN'

all_tickers <- colnames(all_tickers[2:length(all_tickers)])

for (n in 1:length(all_tickers)){
  name <- substring(all_tickers[n], 3)
  #name <- all_tickers[n]
  print(name)
  cname <- paste('$', name, sep='')
  import_file <- paste("C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/",name,"_tweets_full.csv", sep = "")
  temp_df <- read.csv(import_file, header = TRUE)
  temp_df <- temp_df %>% mutate(tag = ifelse(str_detect(temp_df$tweet, fixed(cname,  ignore_case=TRUE)), TRUE, FALSE))
  temp_df <- temp_df[temp_df$tag == TRUE,]
  temp_df$date <- (as.Date(temp_df$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
  temp_date <- na.omit(temp_df %>% count(date))
  
  temp_xts <- xts(as.numeric(temp_date$n), order.by = as.Date(temp_date$date))
  colnames(temp_xts) <- name
  
  df <- cbind(df, temp_xts[,1])
}

df[is.na(df)] <- 0

quarterly <- aggregate(df, as.yearqtr, mean)

sum_ <- rowSums(quarterly)

weights <- xts(round(quarterly/rowSums(quarterly), 4))

p <- dygraph(weights)

write.zoo(weights,file="C:/Users/jango/code/research_env/USI/test.csv", row.names=FALSE,col.names=TRUE,sep=",")

read.csv('C:/Users/jango/code/research_env/USI/test.csv', row.names = 'Index')
