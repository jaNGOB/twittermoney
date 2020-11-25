  #load library
library(twitteR)
#load credentials
access_token <- "1722107810-Z7xFpXlXyG69UxQalUVDK2nYHsO2r3tyRh4B48z"
access_secret <- "JxzRKV2hSxFldLXNngQdNwIJ9QpAfUF5r3wrsgsFZUpnb"
consumer_key <- "lLaNua8lftE0mqKbAoeG6sWCq"
consumer_secret <- "JiyDyPTIqkqNOhmu5KZglDUjJqrrsxWMP6ClWYf3dlMwsIakrD"
bearer_token <- "AAAAAAAAAAAAAAAAAAAAAM3aJwEAAAAATETfeN68xu4DP4YGocODMpaT%2Bz4%3DBxWL7RTynMLfurJrWiA69LlP61D7BDvuxB2zalkVTbTP4xbLsj"

#set up to authenticate
setup_twitter_oauth(consumer_key ,consumer_secret,access_token ,access_secret)


tweets <- twitteR::searchTwitter("$AAPL",n =25,lang ="en")

#strip retweets
strip_retweets(tweets)
