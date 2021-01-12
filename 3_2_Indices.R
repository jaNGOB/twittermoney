# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# December 2020
# 
# Test, if the number of tweets per quarter have any predictive power and if we can generate 
# excess returns using these new weights compared to the index itself.
#
library(dygraphs)
library(xts)
library(PerformanceAnalytics)
library(quantmod)

# Import the data such as weights and stock prices.
tweetsWeights <- read.csv("Data/quarterly_weights.csv")
weights <- read.csv("Data/market_weights.csv", row.names = "Index")
price <- read.csv("Data/stock_prices.csv", row.names = "Index")

weights <- xts(weights, order.by = as.Date(row.names(weights)))
price <- xts(price, order.by = as.Date(row.names(price)))
tweetsWeights <- xts(tweetsWeights[,-1], order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))


to_delete <- c(0)
for (n in 1:length(colnames(price))){
  inornot <- colnames(price)[n]%in%colnames(tweetsWeights)
  if (inornot == F){
    to_delete <- c(to_delete, n)
  } 
}

price <- price[, -to_delete[-1]]

# convert stock prices into daily returns.
pct_returns <- price
for (n in 1:length(colnames(price))){
  new <- dailyReturn(price[,n], type = "log")
  pct_returns[,n] <- new
}
pct_returns[is.na(pct_returns)] <- 0
pct_returns[is.infinite(pct_returns)] <- 0

colnames(weights) == colnames(pct_returns)

IndexCreation <- function(w) {
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

# Create Market Index as well as a weighted Twitter index and plot both.
MarketIndex <- IndexCreation(weights)
TwitterIndex <- IndexCreation(tweetsWeights)

Indices <- merge(TwitterIndex, MarketIndex)
colnames(Indices) <- c("Twitter Index", "Market Index")

IndicesNormReturn <- merge(100*(1+cumsum(MarketIndex)), 100*(1+ cumsum(TwitterIndex)))
colnames(IndicesNormReturn) <- c("Market Index", "Twitter Index")

dygraph(IndicesNormReturn)  %>%
  dySeries("Market Index", label = "Market Index") %>%
  dySeries("Twitter Index", label = "Twitter Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)
charts.PerformanceSummary(Indices)


getSymbols("^IRX", from ="2019-12-31", to = "2020-11-30", src = "yahoo", auto.assign = T)
rf <-mean(IRX$IRX.Adjusted['2020']/100, na.rm=T)
table.AnnualizedReturns(MarketIndex, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)

# Create equal weights for two portfolios for over-and undertweeted companies.
OverUnder <- matrix(NA, nrow = length(weights[,1]), ncol = length(weights[1,]))

for(n in 1:length(weights[1,])) {
  for(q in 1:length(weights[,1])) {
    overTweet <- tweetsWeights[q,n] > weights[q,n]
    if(overTweet == TRUE) {
      OverUnder[q,n] <- "over"
    } else {
      OverUnder[q,n] <- "under"
    }
  }
}

colnames(OverUnder) <- colnames(weights)

EqualWeightsOver <- matrix(NA, nrow = length(weights[,1]), ncol = length(weights[1,]))
EqualWeightsUnder <- matrix(NA, nrow = length(weights[,1]), ncol = length(weights[1,]))

for(g in 1:length(weights[1,])) {
  for(h in 1:length(weights[,1])) {
    TotalOver <- sum(OverUnder[h,] == "over")
    TotalUnder <- sum(OverUnder[h,] == "under")
    OverOrUnder <- OverUnder[h,g] == "over"
     if(OverOrUnder == TRUE) {
       EqualWeightsOver[h,g] <- (1/TotalOver)
       EqualWeightsUnder[h,g] <- 0
     } else {
       EqualWeightsUnder[h,g] <- (1/TotalUnder)
       EqualWeightsOver[h,g] <- 0
  }
 }
}


# Plot only SP500 



EqualWeightsOverXts <- xts(EqualWeightsOver, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))
EqualWeightsUnderXts <- xts(EqualWeightsUnder, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

colnames(EqualWeightsOverXts) <- colnames(weights)
colnames(EqualWeightsUnderXts) <- colnames(weights)

EqualIndexOver <- IndexCreation(EqualWeightsOverXts)
EqualIndexUnder <- IndexCreation(EqualWeightsUnderXts)

EqualIndexReturn <- merge(EqualIndexOver, EqualIndexUnder)
colnames(EqualIndexReturn) <- c("Over", "Under")
charts.PerformanceSummary(EqualIndexReturn)

EqualIndexNormReturn <- merge(100*(1+cumsum(EqualIndexOver)), 100*(1+cumsum(EqualIndexUnder))) 
colnames(EqualIndexNormReturn) <- c("Over", "Under")

dygraph(EqualIndexNormReturn)  %>%
  dySeries("Over", label = "Over Index") %>%
  dySeries("Under", label = "Under Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

# Plot all four indices 
EqualIndexNormReturn <- merge(100*(1+cumsum(MarketIndex)), 100*(1+ cumsum(TwitterIndex)), 100*(1+cumsum(EqualIndexOver)), 100*(1+cumsum(EqualIndexUnder))) 
colnames(EqualIndexNormReturn) <- c("Market Index", "Twitter Index", "Over Index", "Under Index")

dygraph(EqualIndexNormReturn)  %>%
  dyLegend(width = 800) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)
