# Programming Project #14
# Ivana Pallister, Ricardo Cosenza, Alec Bernasconi, Jan Gobeli
# December 2020
# 
# File to:
# 1. Download the market capitalization of the S&P 500 companies.
# 2. Create a new index containing only the biggest 80% of companies by market capitalization.
# 3. Download the daily stock prices of the new index constituents.

# Provide user information to download data from Datastream. This can be replaced by yahoo/quantmod data downloader if 
# Datastream is not available.
options(Datastream.Username = "ZUSI007")
options(Datastream.Password = "OCEAN248")
library("DatastreamDSWS2R")
library("xts")

# download the list of S&P 500 companies
mydsws <- dsws$new()

tickers <- mydsws$listRequest("LS&PCOMP", datatype = "MNEM", requestDate = "0D")
tickers <- na.omit(tickers)

# Clean the tickers to only save their actual ticker without the additional information to where the stock is traded.
tickers2 <- gsub("@", "", tickers[,2])
tickers2 <- gsub("U:", "", tickers2)

write.csv(as.data.frame(tickers2), "Data/tickers_100.csv")

# download the market value of the companies based on data of October 2020.
mv <- matrix(NA,nrow = 1 ,ncol = length(tickers[,2]))

for( t in 1:(length(tickers[,2]))) {
  
  mv[t] <- mydsws$timeSeriesListRequest(instrument = tickers[t,2],
                                          datatype = "MV", startDate = "2020-10-01", endDate = "2020-10-01" , frequency = "D")
  
}

mv <- as.data.frame(mv)
colnames(mv) <- tickers[,2]
row.names(mv) <- 2020
mv <- t(mv)

# select only the companies with large market capitalization (Top 80%) and save it to a new tickers csv.
thres <- quantile(mv, p = 0.2, na.rm = TRUE)

tickers_80 <- subset(mv, mv > thres)
tickers_80  <- t(tickers_80)
tickers_80  <- as.data.frame(tickers_80)

write.csv(tickers_80, "tickers_80.csv")

# creating the quartely weights of the new index with 80% of the companies

mvy <- matrix(NA,nrow = 4 ,ncol = length(tickers_80))

for( i in 1:(length(tickers_80))) {

  mvy[,i] <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_80[i]),
                                          datatype = "MV", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "Q")
  
}

mvy[is.na(mvy)] <- 0
totalMV <- apply(mvy,1, sum)
weights <- matrix(NA,nrow = length(tickers_80)  ,ncol = 4)

for(j in 1:4) {
    
   weights[,j] <- mvy[j,]/totalMV[j]
    
}

weights <- t(weights)
colnames(weights) <- colnames(tickers_80)
weights <- xts(weights, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

# download the stock prices of the 80% of the market
tryDays <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_80[1]),
                                        datatype = "P", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "D")

price <- matrix(NA,nrow = length(tryDays$X.AMZN)  ,ncol = length(tickers_80))

for( k in 1:length(tickers_80)) {

  price[,k] <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_80[k]),
                                           datatype = "P", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "D")
  
}

tickers80 <- gsub("@", "", colnames(tickers_80))
tickers80 <- gsub("U:", "", tickers80)
colnames(weights) <- tickers80

write.zoo(weights, "market_weights.csv", row.names = F, col.names = T, sep = ",")

colnames(price) <- tickers80
price <- xts(price, order.by = as.Date(index(tryDays)))
price[is.na(price)] <- 0

write.zoo(price, "stock_prices.csv",row.names = F, col.names = T, sep = ",")