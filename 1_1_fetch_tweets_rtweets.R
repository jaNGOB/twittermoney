library(rtweet)
library(dplyr)

## install httpuv if not already
if (!requireNamespace("httpuv", quietly = TRUE)) {
  install.packages("httpuv")
}

name <- 'ProgrammingUSI'
app_id <- '19421261'
api <- 'RxEdqHZMSd6LYzhxADq9CQINU'
secret <- 'xQaRGBeBWEr51P6ik9Hf8R7GYY1z5BWoUJAfrcxptQRSltJz8h'
access_token <- '1722107810-OuMtkX9MRFg0lUU5pOUxqeaoONuJXAdQXdnig5L'
access_token_secret <- '9Afe1KSumpG1d5ngAwox6WArvk5jU1p0d4yvHGNe77q5D'

setup_twitter_oauth(api ,secret,access_token ,access_secret)


token <- create_token(
  app = 'ProgrammingUSI',
  consumer_key = api,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_token_secret)


tickers <- c('$AAPL', '$MSFT', '$GE')
tickers_clean <- c('AAPl', 'MSFT', 'GE')

flw <- vector("list", length(tickers_clean))

for (n in 1:length(tickers)){
  flw[[n]] <- search_tweets(tickers[n], n = 100, retryonratelimit=FALSE)
}

saveRDS(flw, file="C:/Users/jango/Documents/USI/1. Semester/Programming_in_Finance_1/Twitter2Money/tweets.RData")

jiji <- readRDS("C:/Users/jango/Documents/USI/1. Semester/Programming_in_Finance_1/Twitter2Money/tweets.RData")

msft_tweets <- search_fullarchive("$MSFT", fromDate = start, toDate = end, env_name = name, token = token)
aapl_tweets <- search_tweets("$AAPL", n = 100000, retryonratelimit=TRUE)
