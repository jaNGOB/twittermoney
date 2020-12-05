require(devtools)
install_github("CharlesCara/DatastreamDSWS2R")
githubinstall("CharlesCara/DatastreamDSWS2R")
options(Datastream.Username = "ZUSI007")
options(Datastream.Password = "OCEAN248")
require("DatastreamDSWS2R")
require("xts")
library("rio")
install_formats()

mydsws <- dsws$new()

tickers <- mydsws$listRequest("LS&PCOMP", datatype = "MNEM", requestDate = "0D")
tickers <- na.omit(ticker)

export(tickers, "mnem.csv")

tickers2 <- gsub("@", "", tickers[,2])
tickers2 <- gsub("U:", "", tickers2)
tickers2

tic <- as.data.frame(tickers2)

export(tic, "tickers.csv")

try2 <- matrix(,nrow = 1 ,ncol = length(tickers[,2]))

for( t in 1:(length(tickers[,2]))) {
  
  try2[t] <- mydsws$timeSeriesListRequest(instrument = tickers[t,2],
                                          datatype = "MV", startDate = "2020-10-01", endDate = "2020-10-01" , frequency = "D")
  
}

try2 <- as.data.frame(try2)
colnames(try2) <- tickers[,2]
row.names(try2) <- 2020
try2 <- t(try2)

thres <- quantile(try2, p = 0.2, na.rm = TRUE)

tickers_80 <- subset(try2, try2 > thres)
tickers_80  <- t(tickers_80)
tickers_80  <- as.data.frame(tickers_80)

export(tickers_80, "tickers_80.csv")

price <- matrix(,nrow = 240 ,ncol = length(tickers_80))

for( t in 1:length(tickers_80)) {

  price[t] <- mydsws$timeSeriesListRequest(instrument = colnames(tickers_80[t]),
                                           datatype = "P", startDate = "2020-01-01", endDate = "2020-01-12" , frequency = "D")
  
}


