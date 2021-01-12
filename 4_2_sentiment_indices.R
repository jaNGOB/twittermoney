# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# 26.12.2020
# 
# Code to gauge sentiment of individual tweets and create a dataframe containing daily positive or negative
# average of twitter sentiment.
#
library(sentimentr)
library(ggplot2)
library(PerformanceAnalytics)
library(dplyr)
library(stringr)
library(tidyquant)

price <- read.csv("Data/stock_prices.csv", row.names = "Index")
price <- xts(price, order.by = as.Date(row.names(price)))
daily_sent <- read.csv('Data/daily_sentiment.csv', row.names = 'Index')

# convert stock prices into daily returns.
pct_returns <- price
for (n in 1:length(colnames(price))){
  new <- dailyReturn(price[,n], type = "log")
  pct_returns[,n] <- new
}
pct_returns[is.na(pct_returns)] <- 0
pct_returns[is.infinite(pct_returns)] <- 0

# Create two quarterly weihted portfolios of stocks having positive or negative sentiment on average.

fquarter <- xts(t(sapply(df['2020-01-01'], mean)), order.by = as.Date('2020-01-01'))
squarter <- xts(t(sapply(df['2020-01-02/2020-03'], mean)), order.by = as.Date('2020-04-02'))
tquarter <- xts(t(sapply(df['2020-04/2020-06'], mean)), order.by = as.Date('2020-07-01'))
lquarter <- xts(t(sapply(df['2020-07/2020-09'], mean)), order.by = as.Date('2020-10-01'))

quarterly <- rbind.xts(fquarter,squarter,tquarter,lquarter)
quarterly[is.na(quarterly)] <- 0

QuarterlyIndex<- function(w) {
  # Function to create a xts frame containing the time-series of a weighted 
  #
  # :input w: quarterly weights
  # :output: xts 
  Index1 <- xts(pct_returns["2020/2020-03-31"] %*% t(w[1,]), order.by = as.Date(index(pct_returns["2020/2020-03-31"])))
  Index2 <- xts(pct_returns["2020-04-01/2020-06-30"] %*% t(w[2,]), order.by = as.Date(index(pct_returns["2020-04-01/2020-06-30"])))
  Index3 <- xts(pct_returns["2020-07-01/2020-09-30"] %*% t(w[3,]), order.by = as.Date(index(pct_returns["2020-07-01/2020-09-30"])))
  Index4 <- xts(pct_returns["2020-10-01/2020-11-30"] %*% t(w[4,]), order.by = as.Date(index(pct_returns["2020-10-01/2020-11-30"])))
  
  Index <- rbind.xts(Index1,Index2,Index3,Index4)
  
  return(Index)
}

quarterly_ <- matrix(NA, nrow = length(quarterly[,1]), ncol = length(quarterly[1,]))

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
colnames(EqualIndexNormReturn) <- c("Positive Index", "Negative Index")

getSymbols("^IRX", from ="2019-12-31", to = "2020-11-30", src = "yahoo", auto.assign = T)
rf <-mean(IRX$IRX.Adjusted['2020']/100, na.rm=T)
table.AnnualizedReturns(posIndexQrt, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)
table.AnnualizedReturns(negIndexQrt, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)

QuarterlyIndices <- merge(posIndexQrt, negIndexQrt)
colnames(QuarterlyIndices) <- c('Positive Index', 'Negative Index')

charts.PerformanceSummary(QuarterlyIndices, wealth.index = T, geometric = F, plot.engine = "ggplot2")


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

table.AnnualizedReturns(posIndex, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)
table.AnnualizedReturns(negIndex, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)

EqualIndexNormReturn <- merge(100*(1+cumsum(posIndex)), 100*(1+cumsum(negIndex))) 
colnames(EqualIndexNormReturn) <- c("Positive Index", "Negative Index")

dygraph(EqualIndexNormReturn)  %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

