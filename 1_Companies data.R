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
tickers_100 <- gsub("@", "", tickers[,2])
tickers_100 <- gsub("U:", "", tickers_100)

write.csv(as.data.frame(tickers_100), "Data/tickers_100.csv")

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

tickers_80_clean <- gsub("@", "", colnames(tickers_80))
tickers_80_clean <- gsub("U:", "", tickers_80_clean)

write.csv(tickers_80_clean, "Data/tickers_80.csv", row.names = F)

# For some stocks, no twitter data was available, so those who have no data get discarded. 
# Stocks who were not in the index at the beginning of the year were also dropped from the list.

temp_tickers <- read.csv('Data/tickers_final.csv', header = F)
temp_tickers <- substr(temp_tickers, 2, 9)

toDelete <- c(0)
for (n in 1:length(colnames(tickers_80))){
  name <- gsub('@', '', colnames(tickers_80[n]))
  name <- gsub('U:', '', name)
  inornot <- name%in%temp_tickers
  if (inornot == F){
    toDelete <- c(toDelete, n)
  } 
}

tickers_final <- tickers_80[-toDelete[2:length(toDelete)]]
tickers_final_clean <- tickers_80_clean[-toDelete[2:length(toDelete)]]

write.csv(tickers_final_clean, "Data/tickers.csv", row.names = F)

tickers_final <- read.csv('Data/tickers.csv')

# creating the quartely weights of the new index with 80% of the companies
mvy <- matrix(NA,nrow = 4 ,ncol = length(tickers_final))
for( i in 1:(length(tickers_final))) {

  mvy[,i] <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_final[i]),
                                          datatype = "MV", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "Q")
  
}

mvy[is.na(mvy)] <- 0
totalMV <- apply(mvy,1, sum)
weights <- matrix(NA,nrow = length(tickers_final)  ,ncol = 4)

for(j in 1:4) {
    
   weights[,j] <- mvy[j,]/totalMV[j]
    
}

weights <- t(weights)
colnames(weights) <- tickers_final_clean
weights <- xts(weights, order.by = as.Date(c("2020-01-01", "2020-04-01", "2020-07-01", "2020-10-01")))

# download the stock prices of the 80% of the market
tryDays <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_final[1]),
                                        datatype = "P", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "D")

price <- matrix(NA,nrow = length(tryDays$X.AMZN)  ,ncol = length(tickers_final))

for( k in 1:length(tickers_final)) {

  price[,k] <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_final[k]),
                                           datatype = "P", startDate = "2020-01-01", endDate = "2020-11-30" , frequency = "D")
  
}

write.zoo(weights, "Data/market_weights.csv", row.names = F, col.names = T, sep = ",")

colnames(price) <- tickers_final_clean
price <- xts(price, order.by = as.Date(index(tryDays)))
price[is.na(price)] <- 0

write.zoo(price, "Data/stock_prices.csv",row.names = F, col.names = T, sep = ",")
