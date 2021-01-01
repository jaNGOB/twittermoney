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

price <- read.csv("Data/stock_prices.csv", row.names = "Index")
price <- xts(price, order.by = as.Date(row.names(price)))
daily_sent <- read.csv('Data/daily_sentiment.csv', row.names = 'Index')
daily_sent <- daily_sent[,-134]

# Clean the xts for stocks that were added during the year and not included in the twitter data.
to_delete <- c(0)
for (n in 1:length(colnames(price))){
  inornot <- colnames(price)[n]%in%colnames(daily_sent)
  if (inornot == F){
    to_delete <- c(to_delete, n)
  }
}

price <- price[, -to_delete[-1]]

# convert stock prices into daily returns.
pct_returns <- price
for (n in 1:length(colnames(price))){
  new <- dailyReturn(price[,n], type = "arithmetic")
  pct_returns[,n] <- new
}
pct_returns[is.na(pct_returns)] <- 0
pct_returns[is.infinite(pct_returns)] <- 0


# Create two quarterly weihted portfolios of stocks having positive or negative sentiment on average.
quarterly <- aggregate(df, as.yearqtr, mean)
quarterly <- xts(quarterly, order.by = as.Date(index(quarterly)))
quarterly <- xts(quarterly[,-1], order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))
quarterly[is.na(quarterly)] <- 0

QuarterlyIndex<- function(w) {
  # Function to create a xts frame containing the time-series of a weighted 
  #
  # :input w: quarterly weights
  # :output: xts 
  Index1 <- xts(pct_returns["2020/2020-04-01"] %*% t(w[1,]), order.by = as.Date(index(pct_returns["2020/2020-04-01"])))
  Index2 <- xts(pct_returns["2020-04-01/2020-07-01"] %*% t(w[2,]), order.by = as.Date(index(pct_returns["2020-04-01/2020-07-01"])))
  Index3 <- xts(pct_returns["2020-07-01/2020-10-01"] %*% t(w[3,]), order.by = as.Date(index(pct_returns["2020-07-01/2020-10-01"])))
  Index4 <- xts(pct_returns["2020-10-01/2020-11-30"] %*% t(w[4,]), order.by = as.Date(index(pct_returns["2020-10-01/2020-11-30"])))
  
  Index <- rbind.xts(Index1,Index2,Index3,Index4)
  
  return(Index)
}

quarterly_ <- matrix(NA, nrow = length(weekly[,1]), ncol = length(weekly[1,]))

for(n in 1:length(quarterly[1,])) {
  for(q in 1:length(quarterly[,1])) {
    pos_sent <- quarterly[q,n] > 0
    if(pos_sent == TRUE) {
      quarterly_[q,n] <- "pos"
    } else {
      quarterly_[q,n] <- "neg"
    }
  }
}

negativeQrt <- matrix(NA, nrow = length(quarterly[,1]), ncol = length(quarterly[1,]))
positiveQrt <- matrix(NA, nrow = length(quarterly[,1]), ncol = length(quarterly[1,]))

for(g in 1:length(quarterly[1,])) {
  for(h in 1:length(quarterly[,1])) {
    TotalPositive <- sum(quarterly_[h,] == "pos")
    TotalNegative<- sum(quarterly_[h,] == "neg")
    isNegative <- quarterly_[h,g] == "neg"
    if(isNegative == TRUE) {
      negativeQrt[h,g] <- (1/TotalNegative)
      positiveQrt[h,g] <- 0
    } else {
      positiveQrt[h,g] <- (1/TotalPositive)
      negativeQrt[h,g] <- 0
    }
  }
}

colnames(negativeQrt) <- colnames(quarterly)
colnames(positiveQrt) <- colnames(quarterly)

positiveQrt <- xts(positiveQrt, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))
negativeQrt <- xts(negativeQrt, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

posIndexQrt <- QuarterlyIndex(positiveQrt)
negIndexQrt <- QuarterlyIndex(negativeQrt)

EqualIndexNormReturn <- merge(100*(1+cumsum(posIndexQrt)), 100*(1+cumsum(negIndexQrt)))

plot(EqualIndexNormReturn)


# Create two weekly weihted portfolios of stocks having positive or negative sentiment on average.
weekly <- apply.weekly(daily_sent, mean)
weekly_ <- matrix(NA, nrow = length(weekly[,1]), ncol = length(weekly[1,]))

for(n in 1:length(weekly[1,])) {
  for(q in 1:length(weekly[,1])) {
    pos_sent <- weekly[q,n] > 0
    if(pos_sent == TRUE) {
      weekly_[q,n] <- "pos"
    } else {
      weekly_[q,n] <- "neg"
    }
  }
}

colnames(weekly_) <- colnames(weekly)

negative <- matrix(NA, nrow = length(weekly[,1]), ncol = length(weekly[1,]))
positive <- matrix(NA, nrow = length(weekly[,1]), ncol = length(weekly[1,]))

for(g in 1:length(weekly[1,])) {
  for(h in 1:length(weekly[,1])) {
    TotalPositive <- sum(weekly_[h,] == "pos")
    TotalNegative<- sum(weekly_[h,] == "neg")
    isNegative <- weekly_[h,g] == "neg"
    if(isNegative == TRUE) {
      negative[h,g] <- (1/TotalNegative)
      positive[h,g] <- 0
    } else {
      positive[h,g] <- (1/TotalPositive)
      negative[h,g] <- 0
    }
  }
}

colnames(negative) <- colnames(weekly)
colnames(positive) <- colnames(weekly)

row.names(negative) <- row.names(weekly)
row.names(positive) <- row.names(weekly)

WeeklyIndex <- function(w) {
  # Function to create a xts frame containing the time-series of a weighted 
  #
  # :input w: weekly weights
  # :output: xts 
  index <- xts(pct_returns["2020/2020-01-06"] %*% t(w[1,]), order.by = as.Date(index(pct_returns["2020/2020-01-06"])))
  
  for (n in 2:length(index(w))){
    date_range <- paste(row.names(weekly)[n-1], row.names(weekly)[n], sep = '/')
    temp_index <- xts(pct_returns[date_range] %*% t(w[n,]), order.by = as.Date(index(pct_returns[date_range])))
    index <- rbind.xts(index, temp_index)
  }
  return(index)
}

positive <- xts(positive, order.by = as.Date(row.names(positive)))
negative <- xts(negative, order.by = as.Date(row.names(negative)))

posIndex <- WeeklyIndex(positive)
negIndex <- WeeklyIndex(negative)

EqualIndexNormReturn <- merge(100*(1+cumsum(posIndex)), 100*(1+cumsum(negIndex))) 
colnames(EqualIndexNormReturn) <- c("Positive Index", "Negative Index")

dygraph(EqualIndexNormReturn)  %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

