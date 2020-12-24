library(sentimentr)
library(ggplot2)

all_tickers <- read.csv('C:/Users/jango/code/research_env/USI/tickers_final.csv')

tweets_AMZN <- read.csv('C:/Users/jango/code/research_env/USI/tweets/Actual_Tweets/Tweets/AMZN_tweets_full.csv', header = TRUE) 

tweets_AMZN$date <- (as.Date(tweets_AMZN$date,format="%Y-%m-%d %H:%M:%S",tz=Sys.timezone()))
tweets_AMZN <- tweets_AMZN %>% mutate(tag = ifelse(str_detect(tweets_AMZN$tweet, fixed(cname,  ignore_case=TRUE)), TRUE, FALSE))
tweets_AMZN <- tweets_AMZN[tweets_AMZN$tag == TRUE,]

tweets_AMZN['sentiment'] <- NA

for (i in 1:length(tweets_AMZN$tweet)){
  tweets_AMZN$sentiment[i] <- sentiment_by(tweets_AMZN$tweet[i])$ave_sentiment
}

qplot(tweets_AMZN$sentiment[tweets_AMZN$sentiment != 0], geom="histogram",binwidth=0.05,main="Amazon Twitter Sentiment Histogram")

