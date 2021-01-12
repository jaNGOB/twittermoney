library(dplyr)
library(sentimentr)
library(tidyquant)
library(PerformanceAnalytics)
library(ggplot2)
library(quantmod)

all_tickers <- read.csv('Data/tickers.csv')
sent <- read.csv('Data/daily_sentiment.csv', row.names = 'Index')
count <- read.csv('Data/daily_count.csv', row.names = 'Index')
price <- read.csv("Data/stock_prices.csv", row.names = "Index")
price <- xts(price, order.by = as.Date(row.names(price)))

counter <- function(df, name){
  temp <- na.omit(df %>% count(date))  
  temp <- xts(as.numeric(temp$n), order.by = as.Date(temp$date))
  colnames(temp) <- name
  return(temp)
}

#
# BUllshit based on pointless tweets!
#

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE) 
tweets_AMZN$date <- as.Date(tweets_AMZN$date,format="%Y-%m-%d",tz=Sys.timezone())
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
# Bullshit based on pointless people
#


tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE)
verified <- counter(tweets_AMZN[tweets_AMZN$verified != 0,], 'AMZN')

# veri_bs <- tweets_AMZN[tweets_AMZN$verified == 0,]

df <- xts(as.numeric(verified), order.by = as.Date(index(verified)))
colnames(df) <- 'AMZN'

# Overwrite all_tickers to a new list, containing all tickers without AMZN.
all_tickers <- all_tickers[2:length(row.names(all_tickers)),]

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

combined_verified <- rowSums(df)
combined_count <- rowSums(count)

MktMkt <- 100*(1+cumsum(MarketIndex))

indi <- xts(combined_verified / combined_count, order.by = as.Date(index(df)))

par(mfrow=c(2,1))
chart.CumReturns
chart.CumReturns(MarketIndex, geometric = F, wealth.index = T, plot.engine = 'ggplot2')
plot(indi, type = 'l')


ggarrange()
#
# Bullshit based on pointless tweets, again? Again!
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
#

tweets_AMZN <- read.csv('Data/AMZN_tweets_full.csv', header = TRUE)
leader <- tweets_AMZN[tweets_AMZN$followers / tweets_AMZN$following > 100,]
losers <- tweets_AMZN[tweets_AMZN$followers / tweets_AMZN$following <= 100,]

dates_leader <- counter(leader, 'leaders')
dates_loser<- counter(losers, 'losers')

indi <- dates_leader / dates
indi_z <- scale(indi)

par(mfrow=c(2,1))
plot(AMZN$AMZN.Adjusted)
plot(indi)
