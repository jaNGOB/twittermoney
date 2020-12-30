library(dygraphs)

setwd("C:/Users/maria/Downloads/Twittermoney-main")
tweetsWeights <- read.csv("C:/Users/maria/Downloads/Twittermoney-main/quarterly_weights.csv")
tick <- read.csv("C:/Users/maria/Downloads/Twittermoney-main/tickers_final.csv")

tweetsWeightsXts <- xts(tweetsWeights[,-1], order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

tweetsWeightsXts2 <- tweetsWeightsXts[,-134]
  
price2 <- price[,-100]
price3 <- price2[,-104]
price3a <- price3[,-136]
price4 <- price3a[,-327]
price5 <- price4[,-327]

colnames(tweetsWeightsXts2) == colnames(price5)

weights2 <- weights[,-100]
weights3 <- weights2[,-104]
weights3a <- weights3[,-136]
weights4 <- weights3a[,-327]
weights5 <- weights4[,-327]

colnames(weights5) == colnames(price5)

IndexCreation <- function(w) {
  Index1 <- xts(price5["2020/2020-04-01"] %*% t(w[1,]), order.by = as.Date(index(price5["2020/2020-04-01"])))
  Index2 <- xts(price5["2020-04-01/2020-07-01"] %*% t(w[2,]), order.by = as.Date(index(price5["2020-04-01/2020-07-01"])))
  Index3 <- xts(price5["2020-07-01/2020-10-01"] %*% t(w[3,]), order.by = as.Date(index(price5["2020-07-01/2020-10-01"])))
  Index4 <- xts(price5["2020-10-01/2020-11-30"] %*% t(w[4,]), order.by = as.Date(index(price5["2020-10-01/2020-11-30"])))
  
  Index <- rbind.xts(Index1,Index2,Index3,Index4)
  
  return(Index)
}


MarketIndex <- IndexCreation(weights5)

TwitterIndex <- IndexCreation(tweetsWeightsXts2)

Indices <- merge(MarketIndex, TwitterIndex)
colnames(Indices) <- c("Market Index", "Twitter Index")

dygraph(Indices)  %>%
  dySeries("Market Index", label = "Market Index") %>%
  dySeries("Twitter Index", label = "Twitter Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

MarketIndexReturn <- dailyReturn(MarketIndex, type = "arithmetic")
TwitterIndexReturn <- dailyReturn(TwitterIndex, type = "arithmetic")
IndicesReturn <- merge(MarketIndexReturn, TwitterIndexReturn)
colnames(IndicesReturn) <- c("Market Index", "Twitter Index")
charts.PerformanceSummary(IndicesReturn)

IndicesNormReturn <- merge((100+cumsum(MarketIndexReturn)), (100+ cumsum(TwitterIndexReturn)))
colnames(IndicesNormReturn) <- c("Market Index", "Twitter Index")

dygraph(IndicesNormReturn)  %>%
  dySeries("Market Index", label = "Market Index") %>%
  dySeries("Twitter Index", label = "Twitter Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

OverUnder <- matrix(NA, nrow = 4, ncol = 399)

for(n in 1:length(weights5[1,])) {
  for(q in 1:length(weights5[,1])) {
    overTweet <- tweetsWeightsXts[q,n] > weights5[q,n]
    if(overTweet == TRUE) {
      OverUnder[q,n] <- "over"
    } else {
      OverUnder[q,n] <- "under"
    }
  }
}

colnames(OverUnder) <- colnames(weights5)

EqualWeightsOver <- matrix(NA, nrow = length(weights5[,1]), ncol = length(weights5[1,]))
EqualWeightsUnder <- matrix(NA, nrow = length(weights5[,1]), ncol = length(weights5[1,]))

for(g in 1:length(weights5[1,])) {
  for(h in 1:length(weights5[,1])) {
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


EqualWeightsOverXts <- xts(EqualWeightsOver, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))
EqualWeightsUnderXts <- xts(EqualWeightsUnder, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

colnames(EqualWeightsOverXts) <- colnames(weights5)
colnames(EqualWeightsUnderXts) <- colnames(weights5)

EqualIndexOver <- IndexCreation(EqualWeightsOverXts)
EqualIndexUnder <- IndexCreation(EqualWeightsUnderXts)

EqualIndexOverReturn <- dailyReturn(EqualIndexOver, type = "arithmetic")
EqualIndexUnderReturn <- dailyReturn(EqualIndexUnder, type = "arithmetic")

EqualIndexReturn <- merge(EqualIndexOverReturn, EqualIndexUnderReturn)
colnames(EqualIndexReturn) <- c("Over", "Under")
charts.PerformanceSummary(EqualIndexReturn)

EqualIndex <- merge(EqualIndexOver, EqualIndexUnder)
colnames(EqualIndex) <- c("Over", "Under")

dygraph(EqualIndex)  %>%
  dySeries("Over", label = "Over Index") %>%
  dySeries("Under", label = "Under Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)

EqualIndexNormReturn <- merge((100+cumsum(EqualIndexOverReturn)), (100+cumsum(EqualIndexUnderReturn))) 
colnames(EqualIndexNormReturn) <- c("Over", "Under")

dygraph(EqualIndexNormReturn)  %>%
  dySeries("Over", label = "Over Index") %>%
  dySeries("Under", label = "Under Index") %>%
  dyLegend(width = 600) %>%
  dyShading(from = "2020-02-19", to = "2020-04-01", col = "#FFE6E6" ) %>%
  dyOptions(fillGraph = TRUE) %>%
  dyRangeSelector(height = 40)
