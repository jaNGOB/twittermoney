library(rtweet)
library(dplyr)

## install httpuv if not already
if (!requireNamespace("httpuv", quietly = TRUE)) {
  install.packages("httpuv")
}

name <- 'ProgrammingUSI'
api <- 'RxEdqHZMSd6LYzhxADq9CQINU'
secret <- 'xQaRGBeBWEr51P6ik9Hf8R7GYY1z5BWoUJAfrcxptQRSltJz8h'
access_token <- '1722107810-OuMtkX9MRFg0lUU5pOUxqeaoONuJXAdQXdnig5L'
access_token_secret <- '9Afe1KSumpG1d5ngAwox6WArvk5jU1p0d4yvHGNe77q5D'


token <- create_token(
  app = 'ProgrammingUSI',
  consumer_key = api,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_token_secret)

team_rstats <- search_tweets("#rstats", n = 500)
team_rstats

aapl_tweets <- search_tweets("$AAPL", n = 25000, retryonratelimit=TRUE)


ts_plot(aapl_tweets)
