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
library(ggplot2)

# Import the data such as weights and stock prices.
tweetsWeights <- read.csv("Data/quarterly_weights.csv")
weights <- read.csv("Data/market_weights.csv", row.names = "Index")
price <- read.csv("Data/stock_prices.csv", row.names = "Index")

weights <- xts(weights, order.by = as.Date(row.names(weights)))
price <- xts(price, order.by = as.Date(row.names(price)))
tweetsWeights <- xts(tweetsWeights[,-1], order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

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

# Create a plot of only the S&P 500
colnames(MarketIndex) <- "Modified S&P 500"
chart.CumReturns(MarketIndex, geometric = F, colorset = 1, main = "S&P 500 modified",
                 plot.engine = "ggplot2", wealth.index = T )

Indices <- merge(TwitterIndex, MarketIndex)
colnames(Indices) <- c("Twitter Index", "Market Index")

# Create a plot combining the newly created Twitter Index and the Market Index
IndicesNormReturn <- merge(100*(1+cumsum(MarketIndex)), 100*(1+ cumsum(TwitterIndex)))
colnames(IndicesNormReturn) <- c("Market Index", "Twitter Index")

dygraph(IndicesNormReturn)  %>%
  dySeries("Market Index", label = "Market Index") %>%
  dySeries("Twitter Index", label = "Twitter Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

charts.PerformanceSummary(Indices, wealth.index = T, geometric = F, plot.engine = "ggplot2")

# Import "IRX" which is a 13-week treasury bill yield index from yahoo finance and use it as the risk-free.
getSymbols("^IRX", from ="2019-12-31", to = "2020-11-30", src = "yahoo", auto.assign = T)
rf <-mean(IRX$IRX.Adjusted['2020']/100, na.rm=T)

# Create Annualized Returns.
table.AnnualizedReturns(MarketIndex, Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)

# Create equal weights for two portfolios for over-and undertweeted companies.
# The first step here is, to decide if a company is undertweeted or not compared to the S&P 500 weights.
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

# Now, create two Indices and equally weight them.
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

# After creating two seperate matrices containing the weights of each stock, this code creates the weighted returns of the indices, 
# creates plots and compares the performance.
EqualWeightsOverXts <- xts(EqualWeightsOver, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))
EqualWeightsUnderXts <- xts(EqualWeightsUnder, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

colnames(EqualWeightsOverXts) <- colnames(weights)
colnames(EqualWeightsUnderXts) <- colnames(weights)

EqualIndexOver <- IndexCreation(EqualWeightsOverXts)
EqualIndexUnder <- IndexCreation(EqualWeightsUnderXts)

EqualIndexReturn <- merge(EqualIndexOver, EqualIndexUnder)
colnames(EqualIndexReturn) <- c("Over", "Under")

charts.PerformanceSummary(EqualIndexReturn, geometric = F, plot.engine = "plotly")
charts.PerformanceSummary(EqualIndexReturn, wealth.index = T, geometric = F, plot.engine = "ggplot2")

table.AnnualizedReturns(EqualIndexReturn, geometric = F, Rf =rf/length(pct_returns$AMZN["2020"]))

EqualIndexNormReturn <- merge(100*(1+cumsum(EqualIndexOver)), 100*(1+cumsum(EqualIndexUnder))) 
colnames(EqualIndexNormReturn) <- c("Over", "Under")

dygraph(EqualIndexNormReturn)  %>%
  dySeries("Over", label = "Over Index") %>%
  dySeries("Under", label = "Under Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

# Plot all four indices that were just created.
EqualIndexNormReturn <- merge(100*(1+cumsum(MarketIndex)), 100*(1+ cumsum(TwitterIndex)), 100*(1+cumsum(EqualIndexOver)), 100*(1+cumsum(EqualIndexUnder))) 
colnames(EqualIndexNormReturn) <- c("Market Index", "Twitter Index", "Over Index", "Under Index")

dygraph(EqualIndexNormReturn)  %>%
  dyLegend(width = 800) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)


# Create a new strategy that takes the before created matrix of over and underweighted companies and
# builds a portfolio that takes a short position on undertweeted and long position on overtweeted companies.
topWeights <-  matrix(NA, nrow = length(weights[,1]), ncol = length(weights[1,]))

for(g in 1:length(weights[1,])) {
  for(h in 1:length(weights[,1])) {
    OverOrUnder <- OverUnder[h,g] == "over"
    if(OverOrUnder == TRUE) {
      topWeights[h,g] <-  tweetsWeights[h,g]
    } else {
      topWeights[h,g] <- - tweetsWeights[h,g]
    }
  }
}

topWeightsXts <- xts(topWeights, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

colnames(topWeightsXts) <- colnames(weights)

IndexCreation2 <- function(w) {
  # Function designed to create a xts of returns from a long/short strategy with quarterly weighting.
  #
  # :input w: quarterly weights
  # :output: xts 
  Index12 <- xts(pct_returns["2020/2020-03-31"] %*% t(w[1,]), order.by = as.Date(index(pct_returns["2020/2020-03-31"])))
  Index12["2020-03-31"]  <- Index12["2020-03-31"] + ((1-sum(w[1,])) * as.numeric(IRX$IRX.Adjusted["2020-01-02"])/100)
  
  Index22 <- xts(pct_returns["2020-04-01/2020-06-30"] %*% t(w[2,]), order.by = as.Date(index(pct_returns["2020-04-01/2020-06-30"])))
  Index22["2020-06-30"] <-  Index22["2020-06-30"] +((1-sum(w[2,])) * as.numeric(IRX$IRX.Adjusted["2020-04-01"])/100)
  
  Index32 <- xts(pct_returns["2020-07-01/2020-09-30"] %*% t(w[3,]), order.by = as.Date(index(pct_returns["2020-07-01/2020-09-30"])))
  Index32["2020-09-30"] <-   Index32["2020-09-30"] + ((1-sum(w[3,])) * as.numeric(IRX$IRX.Adjusted["2020-07-01"])/100)
  
  Index42 <- xts(pct_returns["2020-10-01/2020-11-30"] %*% t(w[4,]), order.by = as.Date(index(pct_returns["2020-10-01/2020-11-30"])))
  Index42["2020-11-30"] <-   Index42["2020-11-30"] + ((1-sum(w[4,])) * as.numeric(IRX$IRX.Adjusted["2020-10-01"])/100)
  
  Index111 <- rbind.xts(Index12,Index22,Index32,Index42)
  
  return(Index111)
}

topIndex <- IndexCreation2(topWeightsXts)
colnames(topIndex) <- "Long Short Strategy"

topIndexReturn <- 100*(1+cumsum(topIndex)) 
colnames(topIndexReturn) <- "Long Short Strategy"

dygraph(merge(topIndexReturn, IndicesNormReturn))  %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE, colors = c('rgb(46,139,87)','rgb(220,20,60)','rgb(29, 161, 242)')) %>%
  dyRangeSelector(height = 40)

table.AnnualizedReturns(merge(topIndex, Indices), Rf =rf/length(pct_returns$AMZN["2020"]), geometric = F)

charts.PerformanceSummary(merge(topIndex, Indices), geometric = F, plot.engine = "plotly")
charts.PerformanceSummary(merge(topIndex, Indices), wealth.index = T, geometric = F, plot.engine = "ggplot2")
charts.PerformanceSummary(merge(topIndex, Indices[,2]), wealth.index = T, geometric = F, plot.engine = "ggplot2")

